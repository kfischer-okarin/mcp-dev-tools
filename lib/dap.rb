# Base class of requests, responses, and events.
ProtocolMessage = Data.define(:seq, :type)
# Arguments for `cancel` request.
CancelArguments = Data.define(:requestId, :progressId)
# Arguments for `runInTerminal` request.
RunInTerminalRequestArguments = Data.define(:kind, :title, :cwd, :args, :env, :argsCanBeInterpretedByShell)
# Arguments for `startDebugging` request.
StartDebuggingRequestArguments = Data.define(:configuration, :request)
# Arguments for `initialize` request.
InitializeRequestArguments = Data.define(:clientID, :clientName, :adapterID, :locale, :linesStartAt1, :columnsStartAt1, :pathFormat, :supportsVariableType, :supportsVariablePaging, :supportsRunInTerminalRequest, :supportsMemoryReferences, :supportsProgressReporting, :supportsInvalidatedEvent, :supportsMemoryEvent, :supportsArgsCanBeInterpretedByShell, :supportsStartDebuggingRequest, :supportsANSIStyling)
# Arguments for `launch` request. Additional attributes are implementation specific.
LaunchRequestArguments = Data.define(:noDebug, :__restart)
# Arguments for `attach` request. Additional attributes are implementation specific.
AttachRequestArguments = Data.define(:__restart)
# Arguments for `restart` request.
RestartArguments = Data.define(:arguments)
# Arguments for `disconnect` request.
DisconnectArguments = Data.define(:restart, :terminateDebuggee, :suspendDebuggee)
# Arguments for `terminate` request.
TerminateArguments = Data.define(:restart)
# Arguments for `breakpointLocations` request.
BreakpointLocationsArguments = Data.define(:source, :line, :column, :endLine, :endColumn)
# Arguments for `setBreakpoints` request.
SetBreakpointsArguments = Data.define(:source, :breakpoints, :lines, :sourceModified)
# Arguments for `setFunctionBreakpoints` request.
SetFunctionBreakpointsArguments = Data.define(:breakpoints)
# Arguments for `setExceptionBreakpoints` request.
SetExceptionBreakpointsArguments = Data.define(:filters, :filterOptions, :exceptionOptions)
# Arguments for `dataBreakpointInfo` request.
DataBreakpointInfoArguments = Data.define(:variablesReference, :name, :frameId, :bytes, :asAddress, :mode)
# Arguments for `setDataBreakpoints` request.
SetDataBreakpointsArguments = Data.define(:breakpoints)
# Arguments for `setInstructionBreakpoints` request
SetInstructionBreakpointsArguments = Data.define(:breakpoints)
# Arguments for `continue` request.
ContinueArguments = Data.define(:threadId, :singleThread)
# Arguments for `next` request.
NextArguments = Data.define(:threadId, :singleThread, :granularity)
# Arguments for `stepIn` request.
StepInArguments = Data.define(:threadId, :singleThread, :targetId, :granularity)
# Arguments for `stepOut` request.
StepOutArguments = Data.define(:threadId, :singleThread, :granularity)
# Arguments for `stepBack` request.
StepBackArguments = Data.define(:threadId, :singleThread, :granularity)
# Arguments for `reverseContinue` request.
ReverseContinueArguments = Data.define(:threadId, :singleThread)
# Arguments for `restartFrame` request.
RestartFrameArguments = Data.define(:frameId)
# Arguments for `goto` request.
GotoArguments = Data.define(:threadId, :targetId)
# Arguments for `pause` request.
PauseArguments = Data.define(:threadId)
# Arguments for `stackTrace` request.
StackTraceArguments = Data.define(:threadId, :startFrame, :levels, :format)
# Arguments for `scopes` request.
ScopesArguments = Data.define(:frameId)
# Arguments for `variables` request.
VariablesArguments = Data.define(:variablesReference, :filter, :start, :count, :format)
# Arguments for `setVariable` request.
SetVariableArguments = Data.define(:variablesReference, :name, :value, :format)
# Arguments for `source` request.
SourceArguments = Data.define(:source, :sourceReference)
# Arguments for `terminateThreads` request.
TerminateThreadsArguments = Data.define(:threadIds)
# Arguments for `modules` request.
ModulesArguments = Data.define(:startModule, :moduleCount)
# Arguments for `evaluate` request.
EvaluateArguments = Data.define(:expression, :frameId, :line, :column, :source, :context, :format)
# Arguments for `setExpression` request.
SetExpressionArguments = Data.define(:expression, :value, :frameId, :format)
# Arguments for `stepInTargets` request.
StepInTargetsArguments = Data.define(:frameId)
# Arguments for `gotoTargets` request.
GotoTargetsArguments = Data.define(:source, :line, :column)
# Arguments for `completions` request.
CompletionsArguments = Data.define(:frameId, :text, :column, :line)
# Arguments for `exceptionInfo` request.
ExceptionInfoArguments = Data.define(:threadId)
# Arguments for `readMemory` request.
ReadMemoryArguments = Data.define(:memoryReference, :offset, :count)
# Arguments for `writeMemory` request.
WriteMemoryArguments = Data.define(:memoryReference, :offset, :allowPartial, :data)
# Arguments for `disassemble` request.
DisassembleArguments = Data.define(:memoryReference, :offset, :instructionOffset, :instructionCount, :resolveSymbols)
# Arguments for `locations` request.
LocationsArguments = Data.define(:locationReference)
# Information about the capabilities of a debug adapter.
Capabilities = Data.define(:supportsConfigurationDoneRequest, :supportsFunctionBreakpoints, :supportsConditionalBreakpoints, :supportsHitConditionalBreakpoints, :supportsEvaluateForHovers, :exceptionBreakpointFilters, :supportsStepBack, :supportsSetVariable, :supportsRestartFrame, :supportsGotoTargetsRequest, :supportsStepInTargetsRequest, :supportsCompletionsRequest, :completionTriggerCharacters, :supportsModulesRequest, :additionalModuleColumns, :supportedChecksumAlgorithms, :supportsRestartRequest, :supportsExceptionOptions, :supportsValueFormattingOptions, :supportsExceptionInfoRequest, :supportTerminateDebuggee, :supportSuspendDebuggee, :supportsDelayedStackTraceLoading, :supportsLoadedSourcesRequest, :supportsLogPoints, :supportsTerminateThreadsRequest, :supportsSetExpression, :supportsTerminateRequest, :supportsDataBreakpoints, :supportsReadMemoryRequest, :supportsWriteMemoryRequest, :supportsDisassembleRequest, :supportsCancelRequest, :supportsBreakpointLocationsRequest, :supportsClipboardContext, :supportsSteppingGranularity, :supportsInstructionBreakpoints, :supportsExceptionFilterOptions, :supportsSingleThreadExecutionRequests, :supportsDataBreakpointBytes, :breakpointModes, :supportsANSIStyling)
# An `ExceptionBreakpointsFilter` is shown in the UI as an filter option for configuring how exceptions are dealt with.
ExceptionBreakpointsFilter = Data.define(:filter, :label, :description, :default, :supportsCondition, :conditionDescription)
# A structured message object. Used to return errors from requests.
Message = Data.define(:id, :format, :variables, :sendTelemetry, :showUser, :url, :urlLabel)
# A Module object represents a row in the modules view.
# The `id` attribute identifies a module in the modules view and is used in a `module` event for identifying a module for adding, updating or deleting.
# The `name` attribute is used to minimally render the module in the UI.
#
# Additional attributes can be added to the module. They show up in the module view if they have a corresponding `ColumnDescriptor`.
#
# To avoid an unnecessary proliferation of additional attributes with similar semantics but different names, we recommend to re-use attributes from the 'recommended' list below first, and only introduce new attributes if nothing appropriate could be found.
Module = Data.define(:id, :name, :path, :isOptimized, :isUserCode, :version, :symbolStatus, :symbolFilePath, :dateTimeStamp, :addressRange)
# A `ColumnDescriptor` specifies what module attribute to show in a column of the modules view, how to format it,
# and what the column's label should be.
# It is only used if the underlying UI actually supports this level of customization.
ColumnDescriptor = Data.define(:attributeName, :label, :format, :type, :width)
# A Thread
Thread = Data.define(:id, :name)
# A `Source` is a descriptor for source code.
# It is returned from the debug adapter as part of a `StackFrame` and it is used by clients when specifying breakpoints.
Source = Data.define(:name, :path, :sourceReference, :presentationHint, :origin, :sources, :adapterData, :checksums)
# A Stackframe contains the source location.
StackFrame = Data.define(:id, :name, :source, :line, :column, :endLine, :endColumn, :canRestart, :instructionPointerReference, :moduleId, :presentationHint)
# A `Scope` is a named container for variables. Optionally a scope can map to a source or a range within a source.
Scope = Data.define(:name, :presentationHint, :variablesReference, :namedVariables, :indexedVariables, :expensive, :source, :line, :column, :endLine, :endColumn)
# A Variable is a name/value pair.
# The `type` attribute is shown if space permits or when hovering over the variable's name.
# The `kind` attribute is used to render additional properties of the variable, e.g. different icons can be used to indicate that a variable is public or private.
# If the value is structured (has children), a handle is provided to retrieve the children with the `variables` request.
# If the number of named or indexed children is large, the numbers should be returned via the `namedVariables` and `indexedVariables` attributes.
# The client can use this information to present the children in a paged UI and fetch them in chunks.
Variable = Data.define(:name, :value, :type, :presentationHint, :evaluateName, :variablesReference, :namedVariables, :indexedVariables, :memoryReference, :declarationLocationReference, :valueLocationReference)
# Properties of a variable that can be used to determine how to render the variable in the UI.
VariablePresentationHint = Data.define(:kind, :attributes, :visibility, :lazy)
# Properties of a breakpoint location returned from the `breakpointLocations` request.
BreakpointLocation = Data.define(:line, :column, :endLine, :endColumn)
# Properties of a breakpoint or logpoint passed to the `setBreakpoints` request.
SourceBreakpoint = Data.define(:line, :column, :condition, :hitCondition, :logMessage, :mode)
# Properties of a breakpoint passed to the `setFunctionBreakpoints` request.
FunctionBreakpoint = Data.define(:name, :condition, :hitCondition)
# Properties of a data breakpoint passed to the `setDataBreakpoints` request.
DataBreakpoint = Data.define(:dataId, :accessType, :condition, :hitCondition)
# Properties of a breakpoint passed to the `setInstructionBreakpoints` request
InstructionBreakpoint = Data.define(:instructionReference, :offset, :condition, :hitCondition, :mode)
# Information about a breakpoint created in `setBreakpoints`, `setFunctionBreakpoints`, `setInstructionBreakpoints`, or `setDataBreakpoints` requests.
Breakpoint = Data.define(:id, :verified, :message, :source, :line, :column, :endLine, :endColumn, :instructionReference, :offset, :reason)
# A `StepInTarget` can be used in the `stepIn` request and determines into which single target the `stepIn` request should step.
StepInTarget = Data.define(:id, :label, :line, :column, :endLine, :endColumn)
# A `GotoTarget` describes a code location that can be used as a target in the `goto` request.
# The possible goto targets can be determined via the `gotoTargets` request.
GotoTarget = Data.define(:id, :label, :line, :column, :endLine, :endColumn, :instructionPointerReference)
# `CompletionItems` are the suggestions returned from the `completions` request.
CompletionItem = Data.define(:label, :text, :sortText, :detail, :type, :start, :length, :selectionStart, :selectionLength)
# The checksum of an item calculated by the specified algorithm.
Checksum = Data.define(:algorithm, :checksum)
# Provides formatting information for a value.
ValueFormat = Data.define(:hex)
# An `ExceptionFilterOptions` is used to specify an exception filter together with a condition for the `setExceptionBreakpoints` request.
ExceptionFilterOptions = Data.define(:filterId, :condition, :mode)
# An `ExceptionOptions` assigns configuration options to a set of exceptions.
ExceptionOptions = Data.define(:path, :breakMode)
# An `ExceptionPathSegment` represents a segment in a path that is used to match leafs or nodes in a tree of exceptions.
# If a segment consists of more than one name, it matches the names provided if `negate` is false or missing, or it matches anything except the names provided if `negate` is true.
ExceptionPathSegment = Data.define(:negate, :names)
# Detailed information about an exception that has occurred.
ExceptionDetails = Data.define(:message, :typeName, :fullTypeName, :evaluateName, :stackTrace, :innerException)
# Represents a single disassembled instruction.
DisassembledInstruction = Data.define(:address, :instructionBytes, :instruction, :symbol, :location, :line, :column, :endLine, :endColumn, :presentationHint)
# A `BreakpointMode` is provided as a option when setting breakpoints on sources or instructions.
BreakpointMode = Data.define(:mode, :label, :description, :appliesTo)
