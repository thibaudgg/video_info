# A sample Guardfile
# More info at http://github.com/guard/guard#readme

guard 'rspec', :version => 2, :formatter => "instafail" do
  watch('spec/spec_helper.rb')      { "spec" }
  watch(%r{lib/(.+)\.rb})           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{lib/provider/(.+)\.rb})  { "spec/video_info_spec.rb" }
  watch(%r{spec/.+_spec\.rb})
end