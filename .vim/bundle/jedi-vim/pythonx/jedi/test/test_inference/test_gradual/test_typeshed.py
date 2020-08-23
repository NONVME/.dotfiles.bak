import os

import pytest
from parso.utils import PythonVersionInfo

from jedi.inference.gradual import typeshed
from jedi.inference.value import TreeInstance, BoundMethod, FunctionValue, \
    MethodValue, ClassValue
from jedi.inference.names import StubName

TYPESHED_PYTHON3 = os.path.join(typeshed.TYPESHED_PATH, 'stdlib', '3')


def test_get_typeshed_directories():
    def get_dirs(version_info):
        return {
            d.replace(typeshed.TYPESHED_PATH, '').lstrip(os.path.sep)
            for d in typeshed._get_typeshed_directories(version_info)
        }

    def transform(set_):
        return {x.replace('/', os.path.sep) for x in set_}

    dirs = get_dirs(PythonVersionInfo(2, 7))
    assert dirs == transform({'stdlib/2and3', 'stdlib/2', 'third_party/2and3', 'third_party/2'})

    dirs = get_dirs(PythonVersionInfo(3, 4))
    assert dirs == transform({'stdlib/2and3', 'stdlib/3', 'third_party/2and3', 'third_party/3'})

    dirs = get_dirs(PythonVersionInfo(3, 5))
    assert dirs == transform({'stdlib/2and3', 'stdlib/3',
                              'third_party/2and3', 'third_party/3'})

    dirs = get_dirs(PythonVersionInfo(3, 6))
    assert dirs == transform({'stdlib/2and3', 'stdlib/3',
                              'stdlib/3.6', 'third_party/2and3',
                              'third_party/3', 'third_party/3.6'})


def test_get_stub_files():
    def get_map(version_info):
        return typeshed._create_stub_map(version_info)

    map_ = typeshed._create_stub_map(TYPESHED_PYTHON3)
    assert map_['functools'] == os.path.join(TYPESHED_PYTHON3, 'functools.pyi')


def test_function(Script, environment):
    code = 'import threading; threading.current_thread'
    def_, = Script(code).infer()
    value = def_._name._value
    assert isinstance(value, FunctionValue), value

    def_, = Script(code + '()').infer()
    value = def_._name._value
    assert isinstance(value, TreeInstance)

    def_, = Script('import threading; threading.Thread').infer()
    assert isinstance(def_._name._value, ClassValue), def_


def test_keywords_variable(Script):
    code = 'import keyword; keyword.kwlist'
    for seq in Script(code).infer():
        assert seq.name == 'Sequence'
        # This points towards the typeshed implementation
        stub_seq, = seq.goto(only_stubs=True)
        assert typeshed.TYPESHED_PATH in stub_seq.module_path


def test_class(Script):
    def_, = Script('import threading; threading.Thread').infer()
    value = def_._name._value
    assert isinstance(value, ClassValue), value


def test_instance(Script):
    def_, = Script('import threading; threading.Thread()').infer()
    value = def_._name._value
    assert isinstance(value, TreeInstance)


def test_class_function(Script):
    def_, = Script('import threading; threading.Thread.getName').infer()
    value = def_._name._value
    assert isinstance(value, MethodValue), value


def test_method(Script):
    code = 'import threading; threading.Thread().getName'
    def_, = Script(code).infer()
    value = def_._name._value
    assert isinstance(value, BoundMethod), value
    assert isinstance(value._wrapped_value, MethodValue), value

    def_, = Script(code + '()').infer()
    value = def_._name._value
    assert isinstance(value, TreeInstance)
    assert value.class_value.py__name__() == 'str'


def test_sys_exc_info(Script):
    code = 'import sys; sys.exc_info()'
    none, def_ = Script(code + '[1]').infer()
    # It's an optional.
    assert def_.name == 'BaseException'
    assert def_.type == 'instance'
    assert none.name == 'NoneType'

    none, def_ = Script(code + '[0]').infer()
    assert def_.name == 'BaseException'
    assert def_.type == 'class'


def test_sys_getwindowsversion(Script, environment):
    # This should only exist on Windows, but type inference should happen
    # everywhere.
    definitions = Script('import sys; sys.getwindowsversion().major').infer()
    if environment.version_info.major == 2:
        assert not definitions
    else:
        def_, = definitions
        assert def_.name == 'int'


def test_sys_hexversion(Script):
    script = Script('import sys; sys.hexversion')
    def_, = script.complete()
    assert isinstance(def_._name, StubName), def_._name
    assert typeshed.TYPESHED_PATH in def_.module_path
    def_, = script.infer()
    assert def_.name == 'int'


def test_math(Script):
    def_, = Script('import math; math.acos()').infer()
    assert def_.name == 'float'
    value = def_._name._value
    assert value


def test_type_var(Script):
    def_, = Script('import typing; T = typing.TypeVar("T1")').infer()
    assert def_.name == 'TypeVar'
    assert def_.description == 'TypeVar = object()'


@pytest.mark.parametrize(
    'code, full_name', (
        ('import math', 'math'),
        ('from math import cos', 'math.cos')
    )
)
def test_math_is_stub(Script, code, full_name):
    s = Script(code)
    cos, = s.infer()
    wanted = os.path.join('typeshed', 'stdlib', '2and3', 'math.pyi')
    assert cos.module_path.endswith(wanted)
    assert cos.is_stub() is True
    assert cos.goto(only_stubs=True) == [cos]
    assert cos.full_name == full_name

    cos, = s.goto()
    assert cos.module_path.endswith(wanted)
    assert cos.goto(only_stubs=True) == [cos]
    assert cos.is_stub() is True
    assert cos.full_name == full_name


def test_goto_stubs(Script):
    s = Script('import os; os')
    os_module, = s.infer()
    assert os_module.full_name == 'os'
    assert os_module.is_stub() is False
    stub, = os_module.goto(only_stubs=True)
    assert stub.is_stub() is True

    os_module, = s.goto()


def _assert_is_same(d1, d2):
    assert d1.name == d2.name
    assert d1.module_path == d2.module_path
    assert d1.line == d2.line
    assert d1.column == d2.column


@pytest.mark.parametrize('type_', ['goto', 'infer'])
@pytest.mark.parametrize(
    'code', [
        'import os; os.walk',
        'from collections import Counter; Counter',
        'from collections import Counter; Counter()',
        'from collections import Counter; Counter.most_common',
        'from collections import Counter; Counter().most_common',
    ])
def test_goto_stubs_on_itself(Script, code, type_):
    """
    If goto_stubs is used on an identifier in e.g. the stdlib, we should goto
    the stub of it.
    """
    s = Script(code)
    if type_ == 'infer':
        def_, = s.infer()
    else:
        def_, = s.goto(follow_imports=True)
    stub, = def_.goto(only_stubs=True)

    script_on_source = Script(path=def_.module_path)
    if type_ == 'infer':
        definition, = script_on_source.infer(def_.line, def_.column)
    else:
        definition, = script_on_source.goto(def_.line, def_.column)
    same_stub, = definition.goto(only_stubs=True)
    _assert_is_same(same_stub, stub)
    _assert_is_same(definition, def_)
    assert same_stub.module_path != def_.module_path

    # And the reverse.
    script_on_stub = Script(
        path=same_stub.module_path,
    )

    if type_ == 'infer':
        same_definition, = script_on_stub.infer(same_stub.line, same_stub.column)
        same_definition2, = same_stub.infer()
    else:
        same_definition, = script_on_stub.goto(same_stub.line, same_stub.column)
        same_definition2, = same_stub.goto()

    _assert_is_same(same_definition, definition)
    _assert_is_same(same_definition, same_definition2)
