#!/bin/sh
###
#   \file git_diff_wrap
#  
#  ============================================================================
#   Created  on : 19 Apr 2011 13:23:50 by yannick on dev101
#   Last update : 19 Apr 2011 13:23:50 by yannick on dev101
#  
#   Description:
#     found @ http://blog.tplus1.com/index.php/2007/08/29/how-to-use-vimdiff-as-the-subversion-diff-tool/
#             http://technotales.wordpress.com/2009/05/17/git-diff-with-vimdiff/
###
# Then change your $HOME/.gitconfig file to point at that script:
#  [diff]
#    external = git_diff_wrapper
#  [pager]
#    diff =
#
#  add to $HOME/.bashrc
#  function git_diff() {
#    git diff --no-ext-diff -w "$@" | vim -R -
#  }
#
###


# Configure your favorite diff program here.
DIFF="/usr/bin/vimdiff"

# Subversion provides the paths we need as the sixth and seventh
# parameters.
LEFT=${2}
RIGHT=${5}

# Call the diff command (change the following line to make sense for
# your merge program).
$DIFF $LEFT $RIGHT

# Return an errorcode of 0 if no differences were detected, 1 if some were.
# Any other errorcode will be treated as fatal.

### vim:set et ts=2 sts=2 sw=2 ft=sh: ###
