#!/usr/bin/python
"""
    \file scm_status.py
    \author Yannick Drant <yannick@kimian.fr>
    \version 0.0.1
    \brief

   ============================================================================
    Created  on : 2012-01-17 14:30:20 by yannick on dev101
    Last update : 2012-07-20 15:45:11 by yannick on dev101
    Kimian Copyright 2011

    Description
"""

import sys
from subprocess import Popen, PIPE

ESC = "\e"
color_idx = {'0': 2, '16': 1, '256': 0}
default_theme = {
    "scm_def": {"git":{"code":"\302\261"}, "svn":{"code":"s"}},
    "colors":[
      {
        "header": "[%(scm)s " + ESC + "[01;38;05;230m%(branche)s" + ESC +"[0m]",
        "footer":"",
        "empty": " .",
        "untracked": ESC + "[01;38;05;33mD",
        "added":     ESC + "[01;38;05;64mI",
        "modified":  ESC + "[01;38;05;136mR",
        "renamed":   ESC + "[01;38;05;125mT",
        "deleted":   ESC + "[01;38;05;160mY",
        "unmerged":  ESC + "[01;38;05;37m#",
        "untracked_missing": ESC + "[7;30mD" + ESC + "[0m",
        "added_missing":     ESC + "[7;30mI" + ESC + "[0m",
        "modified_missing":  ESC + "[7;30mR" + ESC + "[0m",
        "renamed_missing":   ESC + "[7;30mT" + ESC + "[0m",
        "deleted_missing":   ESC + "[7;30mY" + ESC + "[0m",
        "unmerged_missing":  ESC + "[7;30m#" + ESC + "[0m",
        "reset": ESC + "[0m"
      },{
        "header":"[%(scm)s " + ESC + "[5;37m%(branche)s" + ESC +"[0m]",
        "footer":"",
        "empty": " ",
        "untracked": ESC + "[5;34m U",
        "added":     ESC + "[5;32m A",
        "modified":  ESC + "[5;33m M",
        "renamed":   ESC + "[5;35m R",
        "deleted":   ESC + "[5;31m D",
        "unmerged":  ESC + "[5;37m #",
        "reset": ESC + "[0m"
      },{
        "header":"[%(scm)s %(branche)s]",
        "footer":"",
        "empty": " ",
        "untracked": " U",
        "added":     " A",
        "modified":  " M",
        "renamed":   " R",
        "deleted":   " D",
        "unmerged":  " #",
        "reset": ""
      }]
}

def exec_cmd(command):
  p = Popen(command, stderr=PIPE, stdout=PIPE, close_fds=True)
  p.wait()
  a = (p.stderr.readlines(), p.stdout.readlines(), p.returncode)
  return a

def check_git(theme=default_theme):
  sdef = theme['scm_def']["git"]
  ret = {}
  r = exec_cmd(["git","symbolic-ref","HEAD"])
  if r[2] == 0:
    ret["scm"] = sdef["code"]
    bname = r[1][0].split('/')[2].strip()
    ret["branche"] = bname
    r = exec_cmd(["git","status","--porcelain"])
    if r[2] == 0:
      for l in r[1]:
        if l.startswith("?? "):
          ret["untracked"] = True
        elif l.startswith("A  ") or l.startswith("M  "):
          ret["added"] = True
        elif l.startswith(" M ") or l.startswith("AM ") or l.startswith(" T "):
          ret["modified"] = True
        if l.startswith("R  "):
          ret["renamed"] = True
        if l.startswith(" D "):
          ret["deleted"] = True
        if l.startswith("UU "):
          ret["unmerged"] = True
    return ret
  else:
    return None

def get_svn_branch_name(res):
  url = ""
  repo = ""
  for l in res:
    if l.startswith("URL: "):
      url = l[5:].rstrip()
    elif l.startswith("Repository Root: "):
      repo = l[17:].rstrip()
  return url[len(repo):].split("/")[1]

def check_svn(theme=default_theme):
  sdef = theme['scm_def']["svn"]
  ret = {}
  r = exec_cmd(["svn","info"])
  if r[2] == 0:
    ret["scm"] = sdef['code']
    ret["branche"] = get_svn_branch_name(r[1])
    r = exec_cmd(["svn","status"])
    if r[2] == 0:
      for l in r[1]:
        if l.startswith("? "):
          ret["untracked"] = True
        elif l.startswith("A "):
          ret["added"] = True
        elif l.startswith("M ") or l.startswith("AM ") or l.startswith(" T "):
          ret["modified"] = True
        if l.startswith("R  "):
          ret["renamed"] = True
        if l.startswith("D "):
          ret["deleted"] = True
        if l.startswith("UU "):
          ret["unmerged"] = True
    return ret
  return None


def display_state(state, ctheme):
  result = ctheme["header"]% (state)
  for s in ["untracked","added","modified", "renamed", "deleted", "unmerged"]:
    if state.get(s, False):
      result += ctheme[s]
    else:
      result += ctheme.get(s + '_missing', ctheme['empty'])
  result += ctheme['footer'] % (state) + ctheme["reset"]
  return result

def main(argv):
  """The Main Function"""
  theme = default_theme
  idx = '256'
  if len(argv) > 1:
    idx = argv[1]
  idx = color_idx.get(idx, '0')
  state = None
  for check in [check_git, check_svn]:
    state = check()
    if state:
      break
  if state:
    print display_state(state, theme["colors"][idx])
  else:
    print ""
  sys.exit(0)

if __name__ == '__main__':
  main(sys.argv)

""" vim:set et ts=2 sts=2 sw=2 ft=python: """
