function fish_prompt --description 'Write out the prompt'
	set -l last_status $status

  # User
  set_color $fish_color_user
  echo -n (whoami)
  set_color normal

  echo -n ':'

  # PWD
  set_color $fish_color_cwd
  echo -n (prompt_pwd)
  set_color normal

  set_color $fish_color_cwd
  __terlar_git_prompt
  __fish_hg_prompt
  set_color normal

  # NODE VERSION
  set_color $fish_color_host
  echo -n ' '
  echo -n (node -v)
  echo
  set_color normal

  if not test $last_status -eq 0
    set_color $fish_color_error
  end

  echo -n '> '
  set_color normal
end
