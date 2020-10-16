function m3_tests
  ag -l "m3: 'skipped'" | wc -l
  ag -l "m3: true" | wc -l
end
