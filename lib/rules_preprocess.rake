

# invocations against this rule should only happen when enhanced dependencies are enabled;
# otherwise, dependency tracking will be too shallow and preprocessed files could intermittently
#  fail to be updated when they actually need to be.
rule(/#{PROJECT_PREPROCESS_FILES_PATH}\/#{'.+'}$/ => [
    proc do |task_name|
      return @objects[:file_finder].find_any_file(task_name)
    end  
  ]) do |file|
  raise 'SYSTEM ERROR: Preprocessing rule invoked though neccessary auxiliary dependency support not enabled.' if (PROJECT_USE_AUXILIARY_DEPENDENCIES == false)
  @objects[:generator].generate_preprocessed_file(file.source)
end


# invocations against this rule can always happen as there are no deeper dependencies to consider
rule(/#{PROJECT_PREPROCESS_INCLUDES_PATH}\/#{'.+'}$/ => [
    proc do |task_name|
      return @objects[:file_finder].find_any_file(task_name)
    end  
  ]) do |file|
  @objects[:generator].generate_shallow_includes_list(file.source)
end
