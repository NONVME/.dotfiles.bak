#!/bin/env python3
import subprocess
from googletrans import Translator

def sendmessage():
    translate = Translator()
    text = subprocess.check_output(['xsel', '-o'])
    text = text.decode('utf-8')
    lang = translate.detect(text).lang
    dest_lang = 'enru'.replace(lang, '')
    if dest_lang not in 'enru':
        dest_lang = 'en'
    rus_lang = translate.translate(text, dest=dest_lang)
    subprocess.Popen(['notify-send', " ", rus_lang.text])


if __name__ == '__main__':
    sendmessage()
