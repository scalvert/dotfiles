function run_codemod  
  set codemod $argv[1]
  set transform $argv[2]
  set pattern $argv[3]

  set inputs (ag $pattern -l)
  npx $codemod $transform $inputs
end
