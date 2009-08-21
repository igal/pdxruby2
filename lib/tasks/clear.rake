desc "Clear everything"
task :clear => ["tmp:clear", :clear_file_store]

desc "Clear file store cache"
task :clear_file_store do
  FileUtils.rm_rf "#{RAILS_ROOT}/tmp/cache/#{RAILS_ENV}"
end
