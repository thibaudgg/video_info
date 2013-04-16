# A sample Guardfile
# More info at http://github.com/guard/guard#readme

guard 'rspec', keep_failed: false do
  watch('spec/spec_helper.rb') { "spec" }
  watch(%r{lib/(.+)\.rb})      { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{spec/.+_spec\.rb})
end
