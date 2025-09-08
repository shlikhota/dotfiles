function gcm
  set msg (_ai_commit_subjects | fzf)
  if test -n "$msg"
    git commit -m "$msg"
  else
    echo "No commit message chosen" >&2
  end
end
