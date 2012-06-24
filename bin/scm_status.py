#!/usr/bin/python
"""
    \file scm_status.py
    \author Yannick Drant <yannick@kimian.fr>
    \version 0.0.1
    \brief

   ============================================================================
    Created  on : 2012-01-17 14:30:20 by yannick on dev101
    Last update : 2012-06-22 10:00:24 by yannick on mars
    Kimian Copyright 2011

    Description
"""

import sys
from subprocess import Popen, PIPE

ESC="\e"
color_idx = {'0': 2, '16':1, '256':0}
color = {
    "header"   : ["[%(scm)s:" + ESC + "[01;38;05;254m%(branche)s" + ESC +"[0m]", "[%(scm)s:" + ESC + "[5;37m%(branche)s" + ESC +"[0m]", "[%(scm)s:%(branche)s]"],
    "footer"   : ["", "", ""],
    "untracked": [ESC + "[01;38;05;33m U", ESC + "[5;34m U", " U"],
    "added"    : [ESC + "[01;38;05;64m A", ESC + "[5;32m A", " A"],
    "modified" : [ESC +"[01;38;05;136m M", ESC + "[5;33m M", " M"],
    "renamed"  : [ESC +"[01;38;05;125m R", ESC + "[5;35m R", " R"],
    "deleted"  : [ESC +"[01;38;05;160m D", ESC + "[5;31m D", " D"],
    "unmerged" : [ESC + "[01;38;05;37m #", ESC + "[5;37m #", " #"],
    "empty"    : ["  ", "  ", "  "],
    "reset"    : [ESC + "[0m", ESC + "[0m", ""]
    }

def exec_cmd(command):
  p = Popen(command, stderr=PIPE, stdout=PIPE, close_fds=True)
  p.wait()
  a = (p.stderr.readlines(), p.stdout.readlines(), p.returncode)
  return a

def check_git():
  ret = {}
  r = exec_cmd(["git","symbolic-ref","HEAD"])
  if r[2] == 0:
    ret["scm"] = "git"
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
    if l.startswith("URL"):
      url = l.split(": ")[-1].rstrip()
    elif l.startswith("Repository Root: ") or l.startswith("Racine"):
      repo = l.split(": ")[-1].rstrip()
  return url[len(repo):].split("/")[1]

def check_svn():
  ret = {}
  try:
    r = exec_cmd(["svn","info"])
    if r[2] == 0:
      ret["scm"] = "svn"
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
  except:
    return None
  return None

def display_state(state, idx_col):
  result = color["header"][idx_col]% (state)
  for s in ["untracked","added","modified", "renamed", "deleted", "unmerged"]:
    if state.get(s, False):
      result += color[s][idx_col]
  result +=  color["footer"][idx_col] % (state) + color["reset"][idx_col]
  return result

def main(argv):
  """The Main Function"""
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
    print display_state(state, idx)
  else:
    print ""
  sys.exit(0)

if __name__ == '__main__':
  main(sys.argv)

""" vim:set et ts=2 sts=2 sw=2 ft=python: """
