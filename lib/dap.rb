# Base class of requests, responses, and events.
ProtocolMessage = Data.define(:seq, :type)

# A client or debug adapter initiated request.
Request = Data.define(:seq, :type, :command, :arguments)

# A debug adapter initiated event.
Event = Data.define(:seq, :type, :event, :body)

# Response for a request.
Response = Data.define(:seq, :type, :request_seq, :success, :command, :message, :body)

# On error (whenever `success` is false), the body can provide more details.
ErrorResponse = Data.define(:body)

# The `cancel` request is used by the client in two situations:
# - to indicate that it is no longer interested in the result produced by a specific request issued earlier
# - to cancel a progress sequence.
# Clients should only call this request if the corresponding capability `supportsCancelRequest` is true.
# This request has a hint characteristic: a debug adapter can only be expected to make a 'best effort' in honoring this request but there are no guarantees.
# The `cancel` request may return an error if it could not cancel an operation but a client should refrain from presenting this error to end users.
# The request that got cancelled still needs to send a response back. This can either be a normal result (`success` attribute true) or an error response (`success` attribute false and the `message` set to `cancelled`).
# Returning partial results from a cancelled request is possible but please note that a client has no generic way for detecting that a response is partial or not.
# The progress that got cancelled still needs to send a `progressEnd` event back.
#  A client should not assume that progress just got cancelled after sending the `cancel` request.
CancelRequest = Data.define(:command, :arguments)

# Arguments for `cancel` request.
CancelArguments = Data.define(:request_id, :progress_id)

CancelResponse = Data.define

# This event indicates that the debug adapter is ready to accept configuration requests (e.g. `setBreakpoints`, `setExceptionBreakpoints`).
# A debug adapter is expected to send this event when it is ready to accept configuration requests (but not before the `initialize` request has finished).
# The sequence of events/requests is as follows:
# - adapters sends `initialized` event (after the `initialize` request has returned)
# - client sends zero or more `setBreakpoints` requests
# - client sends one `setFunctionBreakpoints` request (if corresponding capability `supportsFunctionBreakpoints` is true)
# - client sends a `setExceptionBreakpoints` request if one or more `exceptionBreakpointFilters` have been defined (or if `supportsConfigurationDoneRequest` is not true)
# - client sends other future configuration requests
# - client sends one `configurationDone` request to indicate the end of the configuration.
InitializedEvent = Data.define(:event)

# The event indicates that the execution of the debuggee has stopped due to some condition.
# This can be caused by a breakpoint previously set, a stepping request has completed, by executing a debugger statement etc.
StoppedEvent = Data.define(:event, :body)

# The event indicates that the execution of the debuggee has continued.
# Please note: a debug adapter is not expected to send this event in response to a request that implies that execution continues, e.g. `launch` or `continue`.
# It is only necessary to send a `continued` event if there was no previous request that implied this.
ContinuedEvent = Data.define(:event, :body)

# The event indicates that the debuggee has exited and returns its exit code.
ExitedEvent = Data.define(:event, :body)

# The event indicates that debugging of the debuggee has terminated. This does **not** mean that the debuggee itself has exited.
TerminatedEvent = Data.define(:event, :body)

# The event indicates that a thread has started or exited.
ThreadEvent = Data.define(:event, :body)

# The event indicates that the target has produced some output.
OutputEvent = Data.define(:event, :body)

# The event indicates that some information about a breakpoint has changed.
BreakpointEvent = Data.define(:event, :body)

# The event indicates that some information about a module has changed.
ModuleEvent = Data.define(:event, :body)

# The event indicates that some source has been added, changed, or removed from the set of all loaded sources.
LoadedSourceEvent = Data.define(:event, :body)

# The event indicates that the debugger has begun debugging a new process. Either one that it has launched, or one that it has attached to.
ProcessEvent = Data.define(:event, :body)

# The event indicates that one or more capabilities have changed.
# Since the capabilities are dependent on the client and its UI, it might not be possible to change that at random times (or too late).
# Consequently this event has a hint characteristic: a client can only be expected to make a 'best effort' in honoring individual capabilities but there are no guarantees.
# Only changed capabilities need to be included, all other capabilities keep their values.
CapabilitiesEvent = Data.define(:event, :body)

# The event signals that a long running operation is about to start and provides additional information for the client to set up a corresponding progress and cancellation UI.
# The client is free to delay the showing of the UI in order to reduce flicker.
# This event should only be sent if the corresponding capability `supportsProgressReporting` is true.
ProgressStartEvent = Data.define(:event, :body)

# The event signals that the progress reporting needs to be updated with a new message and/or percentage.
# The client does not have to update the UI immediately, but the clients needs to keep track of the message and/or percentage values.
# This event should only be sent if the corresponding capability `supportsProgressReporting` is true.
ProgressUpdateEvent = Data.define(:event, :body)

# The event signals the end of the progress reporting with a final message.
# This event should only be sent if the corresponding capability `supportsProgressReporting` is true.
ProgressEndEvent = Data.define(:event, :body)

# This event signals that some state in the debug adapter has changed and requires that the client needs to re-render the data snapshot previously requested.
# Debug adapters do not have to emit this event for runtime changes like stopped or thread events because in that case the client refetches the new state anyway. But the event can be used for example to refresh the UI after rendering formatting has changed in the debug adapter.
# This event should only be sent if the corresponding capability `supportsInvalidatedEvent` is true.
InvalidatedEvent = Data.define(:event, :body)

# This event indicates that some memory range has been updated. It should only be sent if the corresponding capability `supportsMemoryEvent` is true.
# Clients typically react to the event by re-issuing a `readMemory` request if they show the memory identified by the `memoryReference` and if the updated memory range overlaps the displayed range. Clients should not make assumptions how individual memory references relate to each other, so they should not assume that they are part of a single continuous address range and might overlap.
# Debug adapters can use this event to indicate that the contents of a memory range has changed due to some other request like `setVariable` or `setExpression`. Debug adapters are not expected to emit this event for each and every memory change of a running program, because that information is typically not available from debuggers and it would flood clients with too many events.
MemoryEvent = Data.define(:event, :body)

# This request is sent from the debug adapter to the client to run a command in a terminal.
# This is typically used to launch the debuggee in a terminal provided by the client.
# This request should only be called if the corresponding client capability `supportsRunInTerminalRequest` is true.
# Client implementations of `runInTerminal` are free to run the command however they choose including issuing the command to a command line interpreter (aka 'shell'). Argument strings passed to the `runInTerminal` request must arrive verbatim in the command to be run. As a consequence, clients which use a shell are responsible for escaping any special shell characters in the argument strings to prevent them from being interpreted (and modified) by the shell.
# Some users may wish to take advantage of shell processing in the argument strings. For clients which implement `runInTerminal` using an intermediary shell, the `argsCanBeInterpretedByShell` property can be set to true. In this case the client is requested not to escape any special shell characters in the argument strings.
RunInTerminalRequest = Data.define(:command, :arguments)

# Arguments for `runInTerminal` request.
RunInTerminalRequestArguments = Data.define(:kind, :title, :cwd, :args, :env, :args_can_be_interpreted_by_shell)

# Response to `runInTerminal` request.
RunInTerminalResponse = Data.define(:body)

# This request is sent from the debug adapter to the client to start a new debug session of the same type as the caller.
# This request should only be sent if the corresponding client capability `supportsStartDebuggingRequest` is true.
# A client implementation of `startDebugging` should start a new debug session (of the same type as the caller) in the same way that the caller's session was started. If the client supports hierarchical debug sessions, the newly created session can be treated as a child of the caller session.
StartDebuggingRequest = Data.define(:command, :arguments)

# Arguments for `startDebugging` request.
StartDebuggingRequestArguments = Data.define(:configuration, :request)

StartDebuggingResponse = Data.define

# The `initialize` request is sent as the first request from the client to the debug adapter in order to configure it with client capabilities and to retrieve capabilities from the debug adapter.
# Until the debug adapter has responded with an `initialize` response, the client must not send any additional requests or events to the debug adapter.
# In addition the debug adapter is not allowed to send any requests or events to the client until it has responded with an `initialize` response.
# The `initialize` request may only be sent once.
InitializeRequest = Data.define(:command, :arguments)

# Arguments for `initialize` request.
InitializeRequestArguments = Data.define(:client_id, :client_name, :adapter_id, :locale, :lines_start_at1, :columns_start_at1, :path_format, :supports_variable_type, :supports_variable_paging, :supports_run_in_terminal_request, :supports_memory_references, :supports_progress_reporting, :supports_invalidated_event, :supports_memory_event, :supports_args_can_be_interpreted_by_shell, :supports_start_debugging_request, :supports_ansi_styling)

# Response to `initialize` request.
InitializeResponse = Data.define(:body)

# This request indicates that the client has finished initialization of the debug adapter.
# So it is the last request in the sequence of configuration requests (which was started by the `initialized` event).
# Clients should only call this request if the corresponding capability `supportsConfigurationDoneRequest` is true.
ConfigurationDoneRequest = Data.define(:command, :arguments)

# Arguments for `configurationDone` request.
ConfigurationDoneArguments = Data.define

ConfigurationDoneResponse = Data.define

# This launch request is sent from the client to the debug adapter to start the debuggee with or without debugging (if `noDebug` is true).
# Since launching is debugger/runtime specific, the arguments for this request are not part of this specification.
LaunchRequest = Data.define(:command, :arguments)

# Arguments for `launch` request. Additional attributes are implementation specific.
LaunchRequestArguments = Data.define(:no_debug, :__restart)

LaunchResponse = Data.define

# The `attach` request is sent from the client to the debug adapter to attach to a debuggee that is already running.
# Since attaching is debugger/runtime specific, the arguments for this request are not part of this specification.
AttachRequest = Data.define(:command, :arguments)

# Arguments for `attach` request. Additional attributes are implementation specific.
AttachRequestArguments = Data.define(:__restart)

AttachResponse = Data.define

# Restarts a debug session. Clients should only call this request if the corresponding capability `supportsRestartRequest` is true.
# If the capability is missing or has the value false, a typical client emulates `restart` by terminating the debug adapter first and then launching it anew.
RestartRequest = Data.define(:command, :arguments)

# Arguments for `restart` request.
RestartArguments = Data.define(:arguments)

RestartResponse = Data.define

# The `disconnect` request asks the debug adapter to disconnect from the debuggee (thus ending the debug session) and then to shut down itself (the debug adapter).
# In addition, the debug adapter must terminate the debuggee if it was started with the `launch` request. If an `attach` request was used to connect to the debuggee, then the debug adapter must not terminate the debuggee.
# This implicit behavior of when to terminate the debuggee can be overridden with the `terminateDebuggee` argument (which is only supported by a debug adapter if the corresponding capability `supportTerminateDebuggee` is true).
DisconnectRequest = Data.define(:command, :arguments)

# Arguments for `disconnect` request.
DisconnectArguments = Data.define(:restart, :terminate_debuggee, :suspend_debuggee)

DisconnectResponse = Data.define

# The `terminate` request is sent from the client to the debug adapter in order to shut down the debuggee gracefully. Clients should only call this request if the capability `supportsTerminateRequest` is true.
# Typically a debug adapter implements `terminate` by sending a software signal which the debuggee intercepts in order to clean things up properly before terminating itself.
# Please note that this request does not directly affect the state of the debug session: if the debuggee decides to veto the graceful shutdown for any reason by not terminating itself, then the debug session just continues.
# Clients can surface the `terminate` request as an explicit command or they can integrate it into a two stage Stop command that first sends `terminate` to request a graceful shutdown, and if that fails uses `disconnect` for a forceful shutdown.
TerminateRequest = Data.define(:command, :arguments)

# Arguments for `terminate` request.
TerminateArguments = Data.define(:restart)

TerminateResponse = Data.define

# The `breakpointLocations` request returns all possible locations for source breakpoints in a given range.
# Clients should only call this request if the corresponding capability `supportsBreakpointLocationsRequest` is true.
BreakpointLocationsRequest = Data.define(:command, :arguments)

# Arguments for `breakpointLocations` request.
BreakpointLocationsArguments = Data.define(:source, :line, :column, :end_line, :end_column)

# Response to `breakpointLocations` request.
# Contains possible locations for source breakpoints.
BreakpointLocationsResponse = Data.define(:body)

# Sets multiple breakpoints for a single source and clears all previous breakpoints in that source.
# To clear all breakpoint for a source, specify an empty array.
# When a breakpoint is hit, a `stopped` event (with reason `breakpoint`) is generated.
SetBreakpointsRequest = Data.define(:command, :arguments)

# Arguments for `setBreakpoints` request.
SetBreakpointsArguments = Data.define(:source, :breakpoints, :lines, :source_modified)

# Response to `setBreakpoints` request.
# Returned is information about each breakpoint created by this request.
# This includes the actual code location and whether the breakpoint could be verified.
# The breakpoints returned are in the same order as the elements of the `breakpoints`
# (or the deprecated `lines`) array in the arguments.
SetBreakpointsResponse = Data.define(:body)

# Replaces all existing function breakpoints with new function breakpoints.
# To clear all function breakpoints, specify an empty array.
# When a function breakpoint is hit, a `stopped` event (with reason `function breakpoint`) is generated.
# Clients should only call this request if the corresponding capability `supportsFunctionBreakpoints` is true.
SetFunctionBreakpointsRequest = Data.define(:command, :arguments)

# Arguments for `setFunctionBreakpoints` request.
SetFunctionBreakpointsArguments = Data.define(:breakpoints)

# Response to `setFunctionBreakpoints` request.
# Returned is information about each breakpoint created by this request.
SetFunctionBreakpointsResponse = Data.define(:body)

# The request configures the debugger's response to thrown exceptions. Each of the `filters`, `filterOptions`, and `exceptionOptions` in the request are independent configurations to a debug adapter indicating a kind of exception to catch. An exception thrown in a program should result in a `stopped` event from the debug adapter (with reason `exception`) if any of the configured filters match.
# Clients should only call this request if the corresponding capability `exceptionBreakpointFilters` returns one or more filters.
SetExceptionBreakpointsRequest = Data.define(:command, :arguments)

# Arguments for `setExceptionBreakpoints` request.
SetExceptionBreakpointsArguments = Data.define(:filters, :filter_options, :exception_options)

# Response to `setExceptionBreakpoints` request.
# The response contains an array of `Breakpoint` objects with information about each exception breakpoint or filter. The `Breakpoint` objects are in the same order as the elements of the `filters`, `filterOptions`, `exceptionOptions` arrays given as arguments. If both `filters` and `filterOptions` are given, the returned array must start with `filters` information first, followed by `filterOptions` information.
# The `verified` property of a `Breakpoint` object signals whether the exception breakpoint or filter could be successfully created and whether the condition is valid. In case of an error the `message` property explains the problem. The `id` property can be used to introduce a unique ID for the exception breakpoint or filter so that it can be updated subsequently by sending breakpoint events.
# For backward compatibility both the `breakpoints` array and the enclosing `body` are optional. If these elements are missing a client is not able to show problems for individual exception breakpoints or filters.
SetExceptionBreakpointsResponse = Data.define(:body)

# Obtains information on a possible data breakpoint that could be set on an expression or variable.
# Clients should only call this request if the corresponding capability `supportsDataBreakpoints` is true.
DataBreakpointInfoRequest = Data.define(:command, :arguments)

# Arguments for `dataBreakpointInfo` request.
DataBreakpointInfoArguments = Data.define(:variables_reference, :name, :frame_id, :bytes, :as_address, :mode)

# Response to `dataBreakpointInfo` request.
DataBreakpointInfoResponse = Data.define(:body)

# Replaces all existing data breakpoints with new data breakpoints.
# To clear all data breakpoints, specify an empty array.
# When a data breakpoint is hit, a `stopped` event (with reason `data breakpoint`) is generated.
# Clients should only call this request if the corresponding capability `supportsDataBreakpoints` is true.
SetDataBreakpointsRequest = Data.define(:command, :arguments)

# Arguments for `setDataBreakpoints` request.
SetDataBreakpointsArguments = Data.define(:breakpoints)

# Response to `setDataBreakpoints` request.
# Returned is information about each breakpoint created by this request.
SetDataBreakpointsResponse = Data.define(:body)

# Replaces all existing instruction breakpoints. Typically, instruction breakpoints would be set from a disassembly window.
# To clear all instruction breakpoints, specify an empty array.
# When an instruction breakpoint is hit, a `stopped` event (with reason `instruction breakpoint`) is generated.
# Clients should only call this request if the corresponding capability `supportsInstructionBreakpoints` is true.
SetInstructionBreakpointsRequest = Data.define(:command, :arguments)

# Arguments for `setInstructionBreakpoints` request
SetInstructionBreakpointsArguments = Data.define(:breakpoints)

# Response to `setInstructionBreakpoints` request
SetInstructionBreakpointsResponse = Data.define(:body)

# The request resumes execution of all threads. If the debug adapter supports single thread execution (see capability `supportsSingleThreadExecutionRequests`), setting the `singleThread` argument to true resumes only the specified thread. If not all threads were resumed, the `allThreadsContinued` attribute of the response should be set to false.
ContinueRequest = Data.define(:command, :arguments)

# Arguments for `continue` request.
ContinueArguments = Data.define(:thread_id, :single_thread)

# Response to `continue` request.
ContinueResponse = Data.define(:body)

# The request executes one step (in the given granularity) for the specified thread and allows all other threads to run freely by resuming them.
# If the debug adapter supports single thread execution (see capability `supportsSingleThreadExecutionRequests`), setting the `singleThread` argument to true prevents other suspended threads from resuming.
# The debug adapter first sends the response and then a `stopped` event (with reason `step`) after the step has completed.
NextRequest = Data.define(:command, :arguments)

# Arguments for `next` request.
NextArguments = Data.define(:thread_id, :single_thread, :granularity)

NextResponse = Data.define

# The request resumes the given thread to step into a function/method and allows all other threads to run freely by resuming them.
# If the debug adapter supports single thread execution (see capability `supportsSingleThreadExecutionRequests`), setting the `singleThread` argument to true prevents other suspended threads from resuming.
# If the request cannot step into a target, `stepIn` behaves like the `next` request.
# The debug adapter first sends the response and then a `stopped` event (with reason `step`) after the step has completed.
# If there are multiple function/method calls (or other targets) on the source line,
# the argument `targetId` can be used to control into which target the `stepIn` should occur.
# The list of possible targets for a given source line can be retrieved via the `stepInTargets` request.
StepInRequest = Data.define(:command, :arguments)

# Arguments for `stepIn` request.
StepInArguments = Data.define(:thread_id, :single_thread, :target_id, :granularity)

StepInResponse = Data.define

# The request resumes the given thread to step out (return) from a function/method and allows all other threads to run freely by resuming them.
# If the debug adapter supports single thread execution (see capability `supportsSingleThreadExecutionRequests`), setting the `singleThread` argument to true prevents other suspended threads from resuming.
# The debug adapter first sends the response and then a `stopped` event (with reason `step`) after the step has completed.
StepOutRequest = Data.define(:command, :arguments)

# Arguments for `stepOut` request.
StepOutArguments = Data.define(:thread_id, :single_thread, :granularity)

StepOutResponse = Data.define

# The request executes one backward step (in the given granularity) for the specified thread and allows all other threads to run backward freely by resuming them.
# If the debug adapter supports single thread execution (see capability `supportsSingleThreadExecutionRequests`), setting the `singleThread` argument to true prevents other suspended threads from resuming.
# The debug adapter first sends the response and then a `stopped` event (with reason `step`) after the step has completed.
# Clients should only call this request if the corresponding capability `supportsStepBack` is true.
StepBackRequest = Data.define(:command, :arguments)

# Arguments for `stepBack` request.
StepBackArguments = Data.define(:thread_id, :single_thread, :granularity)

StepBackResponse = Data.define

# The request resumes backward execution of all threads. If the debug adapter supports single thread execution (see capability `supportsSingleThreadExecutionRequests`), setting the `singleThread` argument to true resumes only the specified thread. If not all threads were resumed, the `allThreadsContinued` attribute of the response should be set to false.
# Clients should only call this request if the corresponding capability `supportsStepBack` is true.
ReverseContinueRequest = Data.define(:command, :arguments)

# Arguments for `reverseContinue` request.
ReverseContinueArguments = Data.define(:thread_id, :single_thread)

ReverseContinueResponse = Data.define

# The request restarts execution of the specified stack frame.
# The debug adapter first sends the response and then a `stopped` event (with reason `restart`) after the restart has completed.
# Clients should only call this request if the corresponding capability `supportsRestartFrame` is true.
RestartFrameRequest = Data.define(:command, :arguments)

# Arguments for `restartFrame` request.
RestartFrameArguments = Data.define(:frame_id)

RestartFrameResponse = Data.define

# The request sets the location where the debuggee will continue to run.
# This makes it possible to skip the execution of code or to execute code again.
# The code between the current location and the goto target is not executed but skipped.
# The debug adapter first sends the response and then a `stopped` event with reason `goto`.
# Clients should only call this request if the corresponding capability `supportsGotoTargetsRequest` is true (because only then goto targets exist that can be passed as arguments).
GotoRequest = Data.define(:command, :arguments)

# Arguments for `goto` request.
GotoArguments = Data.define(:thread_id, :target_id)

GotoResponse = Data.define

# The request suspends the debuggee.
# The debug adapter first sends the response and then a `stopped` event (with reason `pause`) after the thread has been paused successfully.
PauseRequest = Data.define(:command, :arguments)

# Arguments for `pause` request.
PauseArguments = Data.define(:thread_id)

PauseResponse = Data.define

# The request returns a stacktrace from the current execution state of a given thread.
# A client can request all stack frames by omitting the startFrame and levels arguments. For performance-conscious clients and if the corresponding capability `supportsDelayedStackTraceLoading` is true, stack frames can be retrieved in a piecemeal way with the `startFrame` and `levels` arguments. The response of the `stackTrace` request may contain a `totalFrames` property that hints at the total number of frames in the stack. If a client needs this total number upfront, it can issue a request for a single (first) frame and depending on the value of `totalFrames` decide how to proceed. In any case a client should be prepared to receive fewer frames than requested, which is an indication that the end of the stack has been reached.
StackTraceRequest = Data.define(:command, :arguments)

# Arguments for `stackTrace` request.
StackTraceArguments = Data.define(:thread_id, :start_frame, :levels, :format)

# Response to `stackTrace` request.
StackTraceResponse = Data.define(:body)

# The request returns the variable scopes for a given stack frame ID.
ScopesRequest = Data.define(:command, :arguments)

# Arguments for `scopes` request.
ScopesArguments = Data.define(:frame_id)

# Response to `scopes` request.
ScopesResponse = Data.define(:body)

# Retrieves all child variables for the given variable reference.
# A filter can be used to limit the fetched children to either named or indexed children.
VariablesRequest = Data.define(:command, :arguments)

# Arguments for `variables` request.
VariablesArguments = Data.define(:variables_reference, :filter, :start, :count, :format)

# Response to `variables` request.
VariablesResponse = Data.define(:body)

# Set the variable with the given name in the variable container to a new value. Clients should only call this request if the corresponding capability `supportsSetVariable` is true.
# If a debug adapter implements both `setVariable` and `setExpression`, a client will only use `setExpression` if the variable has an `evaluateName` property.
SetVariableRequest = Data.define(:command, :arguments)

# Arguments for `setVariable` request.
SetVariableArguments = Data.define(:variables_reference, :name, :value, :format)

# Response to `setVariable` request.
SetVariableResponse = Data.define(:body)

# The request retrieves the source code for a given source reference.
SourceRequest = Data.define(:command, :arguments)

# Arguments for `source` request.
SourceArguments = Data.define(:source, :source_reference)

# Response to `source` request.
SourceResponse = Data.define(:body)

# The request retrieves a list of all threads.
ThreadsRequest = Data.define(:command)

# Response to `threads` request.
ThreadsResponse = Data.define(:body)

# The request terminates the threads with the given ids.
# Clients should only call this request if the corresponding capability `supportsTerminateThreadsRequest` is true.
TerminateThreadsRequest = Data.define(:command, :arguments)

# Arguments for `terminateThreads` request.
TerminateThreadsArguments = Data.define(:thread_ids)

TerminateThreadsResponse = Data.define

# Modules can be retrieved from the debug adapter with this request which can either return all modules or a range of modules to support paging.
# Clients should only call this request if the corresponding capability `supportsModulesRequest` is true.
ModulesRequest = Data.define(:command, :arguments)

# Arguments for `modules` request.
ModulesArguments = Data.define(:start_module, :module_count)

# Response to `modules` request.
ModulesResponse = Data.define(:body)

# Retrieves the set of all sources currently loaded by the debugged process.
# Clients should only call this request if the corresponding capability `supportsLoadedSourcesRequest` is true.
LoadedSourcesRequest = Data.define(:command, :arguments)

# Arguments for `loadedSources` request.
LoadedSourcesArguments = Data.define

# Response to `loadedSources` request.
LoadedSourcesResponse = Data.define(:body)

# Evaluates the given expression in the context of a stack frame.
# The expression has access to any variables and arguments that are in scope.
EvaluateRequest = Data.define(:command, :arguments)

# Arguments for `evaluate` request.
EvaluateArguments = Data.define(:expression, :frame_id, :line, :column, :source, :context, :format)

# Response to `evaluate` request.
EvaluateResponse = Data.define(:body)

# Evaluates the given `value` expression and assigns it to the `expression` which must be a modifiable l-value.
# The expressions have access to any variables and arguments that are in scope of the specified frame.
# Clients should only call this request if the corresponding capability `supportsSetExpression` is true.
# If a debug adapter implements both `setExpression` and `setVariable`, a client uses `setExpression` if the variable has an `evaluateName` property.
SetExpressionRequest = Data.define(:command, :arguments)

# Arguments for `setExpression` request.
SetExpressionArguments = Data.define(:expression, :value, :frame_id, :format)

# Response to `setExpression` request.
SetExpressionResponse = Data.define(:body)

# This request retrieves the possible step-in targets for the specified stack frame.
# These targets can be used in the `stepIn` request.
# Clients should only call this request if the corresponding capability `supportsStepInTargetsRequest` is true.
StepInTargetsRequest = Data.define(:command, :arguments)

# Arguments for `stepInTargets` request.
StepInTargetsArguments = Data.define(:frame_id)

# Response to `stepInTargets` request.
StepInTargetsResponse = Data.define(:body)

# This request retrieves the possible goto targets for the specified source location.
# These targets can be used in the `goto` request.
# Clients should only call this request if the corresponding capability `supportsGotoTargetsRequest` is true.
GotoTargetsRequest = Data.define(:command, :arguments)

# Arguments for `gotoTargets` request.
GotoTargetsArguments = Data.define(:source, :line, :column)

# Response to `gotoTargets` request.
GotoTargetsResponse = Data.define(:body)

# Returns a list of possible completions for a given caret position and text.
# Clients should only call this request if the corresponding capability `supportsCompletionsRequest` is true.
CompletionsRequest = Data.define(:command, :arguments)

# Arguments for `completions` request.
CompletionsArguments = Data.define(:frame_id, :text, :column, :line)

# Response to `completions` request.
CompletionsResponse = Data.define(:body)

# Retrieves the details of the exception that caused this event to be raised.
# Clients should only call this request if the corresponding capability `supportsExceptionInfoRequest` is true.
ExceptionInfoRequest = Data.define(:command, :arguments)

# Arguments for `exceptionInfo` request.
ExceptionInfoArguments = Data.define(:thread_id)

# Response to `exceptionInfo` request.
ExceptionInfoResponse = Data.define(:body)

# Reads bytes from memory at the provided location.
# Clients should only call this request if the corresponding capability `supportsReadMemoryRequest` is true.
ReadMemoryRequest = Data.define(:command, :arguments)

# Arguments for `readMemory` request.
ReadMemoryArguments = Data.define(:memory_reference, :offset, :count)

# Response to `readMemory` request.
ReadMemoryResponse = Data.define(:body)

# Writes bytes to memory at the provided location.
# Clients should only call this request if the corresponding capability `supportsWriteMemoryRequest` is true.
WriteMemoryRequest = Data.define(:command, :arguments)

# Arguments for `writeMemory` request.
WriteMemoryArguments = Data.define(:memory_reference, :offset, :allow_partial, :data)

# Response to `writeMemory` request.
WriteMemoryResponse = Data.define(:body)

# Disassembles code stored at the provided location.
# Clients should only call this request if the corresponding capability `supportsDisassembleRequest` is true.
DisassembleRequest = Data.define(:command, :arguments)

# Arguments for `disassemble` request.
DisassembleArguments = Data.define(:memory_reference, :offset, :instruction_offset, :instruction_count, :resolve_symbols)

# Response to `disassemble` request.
DisassembleResponse = Data.define(:body)

# Looks up information about a location reference previously returned by the debug adapter.
LocationsRequest = Data.define(:command, :arguments)

# Arguments for `locations` request.
LocationsArguments = Data.define(:location_reference)

# Response to `locations` request.
LocationsResponse = Data.define(:body)

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

# This enumeration defines all possible access types for data breakpoints.
DataBreakpointAccessType = Data.define

# Properties of a data breakpoint passed to the `setDataBreakpoints` request.
DataBreakpoint = Data.define(:data_id, :access_type, :condition, :hit_condition)

# Properties of a breakpoint passed to the `setInstructionBreakpoints` request
InstructionBreakpoint = Data.define(:instruction_reference, :offset, :condition, :hit_condition, :mode)

# Information about a breakpoint created in `setBreakpoints`, `setFunctionBreakpoints`, `setInstructionBreakpoints`, or `setDataBreakpoints` requests.
Breakpoint = Data.define(:id, :verified, :message, :source, :line, :column, :end_line, :end_column, :instruction_reference, :offset, :reason)

# The granularity of one 'step' in the stepping requests `next`, `stepIn`, `stepOut`, and `stepBack`.
SteppingGranularity = Data.define

# A `StepInTarget` can be used in the `stepIn` request and determines into which single target the `stepIn` request should step.
StepInTarget = Data.define(:id, :label, :line, :column, :end_line, :end_column)

# A `GotoTarget` describes a code location that can be used as a target in the `goto` request.
# The possible goto targets can be determined via the `gotoTargets` request.
GotoTarget = Data.define(:id, :label, :line, :column, :end_line, :end_column, :instruction_pointer_reference)

# `CompletionItems` are the suggestions returned from the `completions` request.
CompletionItem = Data.define(:label, :text, :sort_text, :detail, :type, :start, :length, :selection_start, :selection_length)

# Some predefined types for the CompletionItem. Please note that not all clients have specific icons for all of them.
CompletionItemType = Data.define

# Names of checksum algorithms that may be supported by a debug adapter.
ChecksumAlgorithm = Data.define

# The checksum of an item calculated by the specified algorithm.
Checksum = Data.define(:algorithm, :checksum)

# Provides formatting information for a value.
ValueFormat = Data.define(:hex)

# Provides formatting information for a stack frame.
StackFrameFormat = Data.define(:hex, :parameters, :parameter_types, :parameter_names, :parameter_values, :line, :module, :include_all)

# An `ExceptionFilterOptions` is used to specify an exception filter together with a condition for the `setExceptionBreakpoints` request.
ExceptionFilterOptions = Data.define(:filter_id, :condition, :mode)

# An `ExceptionOptions` assigns configuration options to a set of exceptions.
ExceptionOptions = Data.define(:path, :break_mode)

# This enumeration defines all possible conditions when a thrown exception should result in a break.
# never: never breaks,
# always: always breaks,
# unhandled: breaks when exception unhandled,
# userUnhandled: breaks if the exception is not handled by user code.
ExceptionBreakMode = Data.define

# An `ExceptionPathSegment` represents a segment in a path that is used to match leafs or nodes in a tree of exceptions.
# If a segment consists of more than one name, it matches the names provided if `negate` is false or missing, or it matches anything except the names provided if `negate` is true.
ExceptionPathSegment = Data.define(:negate, :names)

# Detailed information about an exception that has occurred.
ExceptionDetails = Data.define(:message, :type_name, :full_type_name, :evaluate_name, :stack_trace, :inner_exception)

# Represents a single disassembled instruction.
DisassembledInstruction = Data.define(:address, :instruction_bytes, :instruction, :symbol, :location, :line, :column, :end_line, :end_column, :presentation_hint)

# Logical areas that can be invalidated by the `invalidated` event.
InvalidatedAreas = Data.define

# A `BreakpointMode` is provided as a option when setting breakpoints on sources or instructions.
BreakpointMode = Data.define(:mode, :label, :description, :applies_to)

# Describes one or more type of breakpoint a `BreakpointMode` applies to. This is a non-exhaustive enumeration and may expand as future breakpoint types are added.
BreakpointModeApplicability = Data.define
