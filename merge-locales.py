import os
import re
from pprint import pprint
from shutil import copyfile


def get_files(addon_path: str, ignore: [str] = ["git"]) -> str:
    g = os.walk(addon_path)
    files = []

    for path, dir_list, file_list in g:
        for file_name in file_list:
            need_pass = False
            file_path = os.path.join(path, file_name)
            for keyword in ignore:
                if keyword in file_path:
                    need_pass = True
                    break

            if not need_pass and file_path[-4:] == ".lua":
                files.append(file_path)

    return files


def generate_keys(files: [str]) -> [str]:
    dict_keys = []
    pattern = re.compile(r"L\[\s*[\"\']([\s\S]*?)[\"\']\s*\]")
    concat_pattern = re.compile(r"\"\s*..\s*\"")

    for file in files:
        f = open(file, "r", encoding='utf8')
        content = f.read()
        results = pattern.findall(content)
        for result in results:
            if not result in dict_keys:
                result = concat_pattern.sub("", result)
                dict_keys.append(result)

        f.close()

    return dict_keys


def get_exist_locale_list(locale_path: str) -> {str: str}:
    g = os.walk(locale_path)
    locale_files = {}

    for path, dir_list, file_list in g:
        for file_name in file_list:
            need_pass = False
            file_path = os.path.join(path, file_name)
            if not need_pass and file_path[-4:] == ".lua":
                lang_code = file_name[:-4]
                locale_files[lang_code] = file_path

    return locale_files


def get_exist_locales(file: str) -> {str: str}:
    locales = {}
    pattern = re.compile(r"L\[[\"\'](.+?)[\"\']\][\s]+=[\s]+[\"\'](.*)[\"\']")

    for line in open(file, encoding='utf8'):
        results = pattern.findall(line)
        for result in results:
            key = result[0]
            value = result[1]
            locales[key] = value

    return locales


def add_other_locales(path: str, exist_locales={str: str}):
    locale_files = get_exist_locale_list(locale_path=path)
    temp_locales = {}

    for lang_code, path in locale_files.items():
        temp_locales[lang_code] = get_exist_locales(path)

    for lang_code, temp_locale in temp_locales.items():
        try:
            exist_translations = exist_locales[lang_code]
            for k, v in temp_locale.items():
                try:
                    exist_translation = exist_translations[k]
                except KeyError:
                    exist_locales[lang_code][k] = v
        except:
            pass


def update_locales(keys, old: {str: str}, del_no_use: bool = True) -> {str: str}:
    if del_no_use:
        new = {}
    else:
        new = old.copy()

    for key in keys:
        try:
            string = old[key]
            # string = string.replace("，", ",").replace("。", ".")
            new[key] = string
        except KeyError:
            new[key] = ""

    return new

#

addon_path = "./"

# Scan all locale strings
files = get_files(addon_path, ignore=["git", "github", "vscode", "locales", "libs"])
keys = generate_keys(files)
keys.sort()

# Scan and save all translated locale strings
locale_files = get_exist_locale_list(addon_path + "locales")
exist_locales = {}
for lang_code, path in locale_files.items():
    exist_locales[lang_code] = get_exist_locales(path)

# Sort translations and update locale strings
new_locales = {}
for lang_code in exist_locales:
    new_locales[lang_code] = update_locales(keys, exist_locales[lang_code])

# Generate new locale files
for lang_code, path in locale_files.items():
    # copyfile(path, path.replace(".lua", ".bak"))
    file = open(path, "w", encoding='utf8')

    file.write('-- This file is automatically generated by the localization tool\n')
    file.write('-- https://github.com/fang2hou/WindToolsScripts/tree/master/MergeLocales\n\n')

    file.write('local F, C = unpack(select(2, ...))\n')
    file.write('local L = F.Libs.ACL:NewLocale(C.ADDON_NAME, ')

    if lang_code == "enUS":
        file.write('"enUS", true, not C.IS_DEVELOPER)\n')
    else:
        file.write('"{}")\n'.format(lang_code))

    file.write('if not L then return end\n\n')

    for key, value in new_locales[lang_code].items():
        if value != "":
            file.write('L["{}"] = "{}"\n'.format(key, value))
        else:
            file.write('L["{}"] = true\n'.format(key))

    file.close()
