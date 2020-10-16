function find_sinon
  for pattern in "sinon\.sandbox\.create\(\)" "sinon\.sandbox\.stub\(\)" "sinon\.stub\(\)" "sinon\.sandbox\.spy\(\)" "sinon\.spy\(\)"
    set -l value (ag $pattern | wc -l)
    echo "$pattern: $value"
  end
end
