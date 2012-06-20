if [ "$CORRECT_ALL" = true ]
then
  setopt correct_all
fi

  
alias man='nocorrect man'
alias mv='nocorrect mv -i'
alias rm='nocorrect rm -i'
alias cp='nocorrect cp -i'
alias mysql='nocorrect mysql'
alias mkdir='nocorrect mkdir'
alias gist='nocorrect gist'
alias heroku='nocorrect heroku'
alias ebuild='nocorrect ebuild'
alias hpodder='nocorrect hpodder'
