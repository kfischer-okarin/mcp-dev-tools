# Base class of requests, responses, and events.
ProtocolMessage = Data.define(:seq, :type)

# Arguments for `cancel` request.
CancelArguments = Data.define(:request_id, :progress_id)

# Arguments for `runInTerminal` request.
RunInTerminalRequestArguments = Data.define(:kind, :title, :cwd, :args, :env, :args_can_be_interpreted_by_shell)

# Arguments for `startDebugging` request.
StartDebuggingRequestArguments = Data.define(:configuration, :request)

# Arguments for `initialize` request.
InitializeRequestArguments = Data.define(:client_id, :client_name, :adapter_id, :locale, :lines_start_at1, :columns_start_at1, :path_format, :supports_variable_type, :supports_variable_paging, :supports_run_in_terminal_request, :supports_memory_references, :supports_progress_reporting, :supports_invalidated_event, :supports_memory_event, :supports_args_can_be_interpreted_by_shell, :supports_start_debugging_request, :supports_ansi_styling)

# Arguments for `launch` request. Additional attributes are implementation specific.
LaunchRequestArguments = Data.define(:no_debug, :__restart)

# Arguments for `attach` request. Additional attributes are implementation specific.
AttachRequestArguments = Data.define(:__restart)

# Arguments for `restart` request.
RestartArguments = Data.define(:arguments)

# Arguments for `disconnect` request.
DisconnectArguments = Data.define(:restart, :terminate_debuggee, :suspend_debuggee)

# Arguments for `terminate` request.
TerminateArguments = Data.define(:restart)

# Arguments for `breakpointLocations` request.
BreakpointLocationsArguments = Data.define(:source, :line, :column, :end_line, :end_column)

# Arguments for `setBreakpoints` request.
SetBreakpointsArguments = Data.define(:source, :breakpoints, :lines, :source_modified)

# Arguments for `setFunctionBreakpoints` request.
SetFunctionBreakpointsArguments = Data.define(:breakpoints)

# Arguments for `setExceptionBreakpoints` request.
SetExceptionBreakpointsArguments = Data.define(:filters, :filter_options, :exception_options)

# Arguments for `dataBreakpointInfo` request.
DataBreakpointInfoArguments = Data.define(:variables_reference, :name, :frame_id, :bytes, :as_address, :mode)

# Arguments for `setDataBreakpoints` request.
SetDataBreakpointsArguments = Data.define(:breakpoints)

# Arguments for `setInstructionBreakpoints` request
SetInstructionBreakpointsArguments = Data.define(:breakpoints)

# Arguments for `continue` request.
ContinueArguments = Data.define(:thread_id, :single_thread)

# Arguments for `next` request.
NextArguments = Data.define(:thread_id, :single_thread, :granularity)

# Arguments for `stepIn` request.
StepInArguments = Data.define(:thread_id, :single_thread, :target_id, :granularity)

# Arguments for `stepOut` request.
StepOutArguments = Data.define(:thread_id, :single_thread, :granularity)

# Arguments for `stepBack` request.
StepBackArguments = Data.define(:thread_id, :single_thread, :granularity)

# Arguments for `reverseContinue` request.
ReverseContinueArguments = Data.define(:thread_id, :single_thread)

# Arguments for `restartFrame` request.
RestartFrameArguments = Data.define(:frame_id)

# Arguments for `goto` request.
GotoArguments = Data.define(:thread_id, :target_id)

# Arguments for `pause` request.
PauseArguments = Data.define(:thread_id)

# Arguments for `stackTrace` request.
StackTraceArguments = Data.define(:thread_id, :start_frame, :levels, :format)

# Arguments for `scopes` request.
ScopesArguments = Data.define(:frame_id)

# Arguments for `variables` request.
VariablesArguments = Data.define(:variables_reference, :filter, :start, :count, :format)

# Arguments for `setVariable` request.
SetVariableArguments = Data.define(:variables_reference, :name, :value, :format)

# Arguments for `source` request.
SourceArguments = Data.define(:source, :source_reference)

# Arguments for `terminateThreads` request.
TerminateThreadsArguments = Data.define(:thread_ids)

# Arguments for `modules` request.
ModulesArguments = Data.define(:start_module, :module_count)

# Arguments for `evaluate` request.
EvaluateArguments = Data.define(:expression, :frame_id, :line, :column, :source, :context, :format)

# Arguments for `setExpression` request.
SetExpressionArguments = Data.define(:expression, :value, :frame_id, :format)

# Arguments for `stepInTargets` request.
StepInTargetsArguments = Data.define(:frame_id)

# Arguments for `gotoTargets` request.
GotoTargetsArguments = Data.define(:source, :line, :column)

# Arguments for `completions` request.
CompletionsArguments = Data.define(:frame_id, :text, :column, :line)

# Arguments for `exceptionInfo` request.
ExceptionInfoArguments = Data.define(:thread_id)

# Arguments for `readMemory` request.
ReadMemoryArguments = Data.define(:memory_reference, :offset, :count)

# Arguments for `writeMemory` request.
WriteMemoryArguments = Data.define(:memory_reference, :offset, :allow_partial, :data)

# Arguments for `disassemble` request.
DisassembleArguments = Data.define(:memory_reference, :offset, :instruction_offset, :instruction_count, :resolve_symbols)

# Arguments for `locations` request.
LocationsArguments = Data.define(:location_reference)

# Information about the capabilities of a debug adapter.
Capabilities = Data.define(:supports_configuration_done_request, :supports_function_breakpoints, :supports_conditional_breakpoints, :supports_hit_conditional_breakpoints, :supports_evaluate_for_hovers, :exception_breakpoint_filters, :supports_step_back, :supports_set_variable, :supports_restart_frame, :supports_goto_targets_request, :supports_step_in_targets_request, :supports_completions_request, :completion_trigger_characters, :supports_modules_request, :additional_module_columns, :supported_checksum_algorithms, :supports_restart_request, :supports_exception_options, :supports_value_formatting_options, :supports_exception_info_request, :support_terminate_debuggee, :support_suspend_debuggee, :supports_delayed_stack_trace_loading, :supports_loaded_sources_request, :supports_log_points, :supports_terminate_threads_request, :supports_set_expression, :supports_terminate_request, :supports_data_breakpoints, :supports_read_memory_request, :supports_write_memory_request, :supports_disassemble_request, :supports_cancel_request, :supports_breakpoint_locations_request, :supports_clipboard_context, :supports_stepping_granularity, :supports_instruction_breakpoints, :supports_exception_filter_options, :supports_single_thread_execution_requests, :supports_data_breakpoint_bytes, :breakpoint_modes, :supports_ansi_styling)

# An `ExceptionBreakpointsFilter` is shown in the UI as an filter option for configuring how exceptions are dealt with.
ExceptionBreakpointsFilter = Data.define(:filter, :label, :description, :default, :supports_condition, :condition_description)

# A structured message object. Used to return errors from requests.
Message = Data.define(:id, :format, :variables, :send_telemetry, :show_user, :url, :url_label)

# A Module object represents a row in the modules view.
# The `id` attribute identifies a module in the modules view and is used in a `module` event for identifying a module for adding, updating or deleting.
# The `name` attribute is used to minimally render the module in the UI.
#
# Additional attributes can be added to the module. They show up in the module view if they have a corresponding `ColumnDescriptor`.
#
# To avoid an unnecessary proliferation of additional attributes with similar semantics but different names, we recommend to re-use attributes from the 'recommended' list below first, and only introduce new attributes if nothing appropriate could be found.
Module = Data.define(:id, :name, :path, :is_optimized, :is_user_code, :version, :symbol_status, :symbol_file_path, :date_time_stamp, :address_range)

# A `ColumnDescriptor` specifies what module attribute to show in a column of the modules view, how to format it,
# and what the column's label should be.
# It is only used if the underlying UI actually supports this level of customization.
ColumnDescriptor = Data.define(:attribute_name, :label, :format, :type, :width)

# A Thread
Thread = Data.define(:id, :name)

# A `Source` is a descriptor for source code.
# It is returned from the debug adapter as part of a `StackFrame` and it is used by clients when specifying breakpoints.
Source = Data.define(:name, :path, :source_reference, :presentation_hint, :origin, :sources, :adapter_data, :checksums)

# A Stackframe contains the source location.
StackFrame = Data.define(:id, :name, :source, :line, :column, :end_line, :end_column, :can_restart, :instruction_pointer_reference, :module_id, :presentation_hint)

# A `Scope` is a named container for variables. Optionally a scope can map to a source or a range within a source.
Scope = Data.define(:name, :presentation_hint, :variables_reference, :named_variables, :indexed_variables, :expensive, :source, :line, :column, :end_line, :end_column)

# A Variable is a name/value pair.
# The `type` attribute is shown if space permits or when hovering over the variable's name.
# The `kind` attribute is used to render additional properties of the variable, e.g. different icons can be used to indicate that a variable is public or private.
# If the value is structured (has children), a handle is provided to retrieve the children with the `variables` request.
# If the number of named or indexed children is large, the numbers should be returned via the `namedVariables` and `indexedVariables` attributes.
# The client can use this information to present the children in a paged UI and fetch them in chunks.
Variable = Data.define(:name, :value, :type, :presentation_hint, :evaluate_name, :variables_reference, :named_variables, :indexed_variables, :memory_reference, :declaration_location_reference, :value_location_reference)

# Properties of a variable that can be used to determine how to render the variable in the UI.
VariablePresentationHint = Data.define(:kind, :attributes, :visibility, :lazy)

# Properties of a breakpoint location returned from the `breakpointLocations` request.
BreakpointLocation = Data.define(:line, :column, :end_line, :end_column)

# Properties of a breakpoint or logpoint passed to the `setBreakpoints` request.
SourceBreakpoint = Data.define(:line, :column, :condition, :hit_condition, :log_message, :mode)

# Properties of a breakpoint passed to the `setFunctionBreakpoints` request.
FunctionBreakpoint = Data.define(:name, :condition, :hit_condition)

# Properties of a data breakpoint passed to the `setDataBreakpoints` request.
DataBreakpoint = Data.define(:data_id, :access_type, :condition, :hit_condition)

# Properties of a breakpoint passed to the `setInstructionBreakpoints` request
InstructionBreakpoint = Data.define(:instruction_reference, :offset, :condition, :hit_condition, :mode)

# Information about a breakpoint created in `setBreakpoints`, `setFunctionBreakpoints`, `setInstructionBreakpoints`, or `setDataBreakpoints` requests.
Breakpoint = Data.define(:id, :verified, :message, :source, :line, :column, :end_line, :end_column, :instruction_reference, :offset, :reason)

# A `StepInTarget` can be used in the `stepIn` request and determines into which single target the `stepIn` request should step.
StepInTarget = Data.define(:id, :label, :line, :column, :end_line, :end_column)

# A `GotoTarget` describes a code location that can be used as a target in the `goto` request.
# The possible goto targets can be determined via the `gotoTargets` request.
GotoTarget = Data.define(:id, :label, :line, :column, :end_line, :end_column, :instruction_pointer_reference)

# `CompletionItems` are the suggestions returned from the `completions` request.
CompletionItem = Data.define(:label, :text, :sort_text, :detail, :type, :start, :length, :selection_start, :selection_length)

# The checksum of an item calculated by the specified algorithm.
Checksum = Data.define(:algorithm, :checksum)

# Provides formatting information for a value.
ValueFormat = Data.define(:hex)

# An `ExceptionFilterOptions` is used to specify an exception filter together with a condition for the `setExceptionBreakpoints` request.
ExceptionFilterOptions = Data.define(:filter_id, :condition, :mode)

# An `ExceptionOptions` assigns configuration options to a set of exceptions.
ExceptionOptions = Data.define(:path, :break_mode)

# An `ExceptionPathSegment` represents a segment in a path that is used to match leafs or nodes in a tree of exceptions.
# If a segment consists of more than one name, it matches the names provided if `negate` is false or missing, or it matches anything except the names provided if `negate` is true.
ExceptionPathSegment = Data.define(:negate, :names)

# Detailed information about an exception that has occurred.
ExceptionDetails = Data.define(:message, :type_name, :full_type_name, :evaluate_name, :stack_trace, :inner_exception)

# Represents a single disassembled instruction.
DisassembledInstruction = Data.define(:address, :instruction_bytes, :instruction, :symbol, :location, :line, :column, :end_line, :end_column, :presentation_hint)

# A `BreakpointMode` is provided as a option when setting breakpoints on sources or instructions.
BreakpointMode = Data.define(:mode, :label, :description, :applies_to)

