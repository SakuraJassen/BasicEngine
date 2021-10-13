using System.Net;
using System.Collections;
using System;
using BasicEngine.Interface;

namespace BasicEngine.Console
{
	class CommandHandler
	{
		Socket mListenSocket = new Socket() ~ delete _;
		Socket mClient = new Socket() ~ delete _;

		List<Command> mCommands = new List<Command>() ~ DeleteContainerAndItems!(_);
		Dictionary<String, String> mVariables = new Dictionary<String, String>() ~ DeleteDictionaryAndKeysAndValues!(_);

		public this()
		{
			Socket.Init();
			mListenSocket.Listen(545);
			mClient.Blocking = false;
			init();
		}

		private void init()
		{
			RegisterCommand(new Help());
			RegisterCommand(new ListCommand());
			RegisterCommand(new Set());
			RegisterCommand(new BoolSet());
			RegisterCommand(new BitSet());
			RegisterCommand(new Toggle());
		}

		public void Update()
		{
			AcceptConnection();
			String command = scope String();
			CheckForMassage(command);

			if(!command.IsEmpty)
			{
				RunCommand(command);
			}
		}

		public void RegisterCommand(Command cmd)
		{
			mCommands.Add(cmd);
		}

		public void ListCommands()
		{
			SendMassage("Name\tArgs\t- Disc.");
			for(Command cmd in mCommands)
				SendMassage("{}\t({})\t- {}", cmd.CommandText, cmd.ParamCounter, cmd.HelpText);

		}

		public void RunCommand(params Object[] args)
		{
			var buffer = new String();
			for(var arg in args)
				buffer.AppendF("{} ", ToStackString!(arg));

			buffer.RemoveFromEnd(1);
			buffer.Append("\n\r");
			RunCommand(buffer);
			SafeDelete!(buffer);
		}

		public void RunCommand(String cmdText)
		{
			cmdText.RemoveFromEnd(2); // Remove newline and return characters
			var splitCommands = cmdText.Split(';');
			for(var cmd in splitCommands)
			{
				bool success = false;
				List<String> lArgs = new List<String>();

				var splitText = cmd.Split(' ');

				List<String> variableNames = new List<String>();
				for(var key in mVariables.Keys)
					variableNames.Add(key);

				for(var text in splitText)
				{
					String arg = new String(text);
					if(text != "")
					{
						if(lArgs.Count == 0)
						{
							lArgs.Add(arg);
						}
						else
						{
							switch (AutoCompleteByList(arg, variableNames))
							{
							    case .Ok(let index):
									lArgs.Add(ToGlobalString!(mVariables[variableNames[index]]));
									delete arg;
							    case .Err: lArgs.Add(arg);
							}
						}
					}
					else
					{
						delete arg;
					}
				}

				SafeDelete!(variableNames);

				if(lArgs.Count > 0)
				{
					if(lArgs[0] == "help")
					{
						success = true;
						ListCommands();
					}
					else
					{
						success = ExecuteCommand(lArgs);
					}
				}

				if(success)
				{
					String buffer = scope String();
					for(var arg in lArgs)
						buffer.Append(arg, " ");
					buffer.RemoveFromEnd(1);
					SendMassage("Successfully executed '{}' received '{}'!", buffer, cmd);
					SendMassage("");
				}
				else
				{
					SendMassage("Execute failed for '{}'", cmd);
					SendMassage("");
				}

				DeleteContainerAndItems!(lArgs);
			}
		}

		public bool ExecuteCommand(params Object[] args)
		{
			var buffer = new List<String>();
			for(var arg in args)
				buffer.Add(ToGlobalString!(arg));

			bool ret = ExecuteCommand(buffer);
			DeleteContainerAndItems!(buffer);
			return ret;
		}

		public bool ExecuteCommand(List<String> args)
		{
			bool success = false;
			switch (CompleteCommand(args[0]))
			{
			    case .Ok(let commandList):
					if(commandList.Count == 1)
					{
						if(commandList.Front.ParamCounter == args.Count-1)
						{
							delete args[0];
							args[0] = new String(commandList.Front.CommandText);
							commandList.Front.Run(args);
							success = true;
						}
						else
						{
							SendMassage("Not enough parameters!\n\r Expected : '{}' Got : '{}'", commandList.Front.ParamCounter, args.Count-1);
						}
					}
					else
					{
						for(var command in commandList)
						{
							if(command.CommandText == args[0])
							{
								if(commandList.Front.ParamCounter == args.Count-1)
								{
									delete args[0];
									args[0] = new String(command.CommandText);
									command.Run(args);
									success = true;
								}
								else
								{
									SendMassage("Not enough parameters!\n\r Expected : '{}' Got : '{}'", commandList.Front.ParamCounter, args.Count-1);
								}
							}
						}

						if(!success)
						{
							SendMassage("Found {} matches!", commandList.Count);

							for(var command in commandList)
							{
								SendMassage(" - {}", command.CommandText);
							}
							SendMassage("");
						}

					}
					DeleteContainerAndItems!(commandList);
						
			    case .Err: SendMassage("Couldn't find '{}'", args[0]);
			}
			return success;
		}

		public Result<List<Command>> CompleteCommand(String name)
		{
			List<Command> localCommand = new List<Command>();
			for(var cmd in mCommands)
				localCommand.Add(cmd.Create());
			for(int i < name.Length)
			{
				char32 ch = name[i].ToLower;
				for(Command cmd in localCommand)
				{
					if(name.Length > cmd.CommandText.Length)
					{
						@cmd.RemoveFast();
						delete cmd;
					}
					else
					{
						if(cmd.CommandText[i].ToLower != ch)
						{
							@cmd.RemoveFast();
							delete cmd;
						}
					}
				}
				if(localCommand.Count == 1){
					if(i < name.Length-1)
					{
						if(localCommand[0].CommandText[i+1] != name[i+1].ToLower)
						{
							return .Ok(localCommand);
						}
					}
					else
						return .Ok(localCommand);
				}
			}

			return .Ok(localCommand);
		}

		public static Result<int> AutoCompleteByList(String name, List<String> stringContainer)
		{
			List<(int, String)> localString = scope List<(int, String)>();
			{
				int i = 0;
				for(var val in stringContainer.GetEnumerator())
				{
					localString.Add((i++, new String(ToStackString!(val))));
				}
			}

			for(int i < name.Length)
			{
				char32 ch = name[i].ToLower;
				for((int, String) pair in localString)
				{
					if(pair.1[i].ToLower != ch)
					{
						@pair.RemoveFast();
						delete pair.1;
					}
				}
				if(localString.Count == 1){
					if(localString[0].1.Length < name.Length)
					{
						delete localString.Front.1;
						return .Err;
					}
					else if(i < name.Length-1)
					{
						if(localString[0].1[i+1] != name[i+1].ToLower)
						{
							delete localString.Front.1;
							return .Ok(localString.Front.0);
						}
					}
					else
					{
						delete localString.Front.1;
						return .Ok(localString.Front.0);
					}
				}
			}
			return .Err;
		}

		public void RegisterVariable(String key, String value)
		{
			mVariables.Add(key, value);
		}

		private void AcceptConnection()
		{
			if(!mClient.IsConnected)
			{	
				if(mClient.AcceptFrom(mListenSocket) case .Ok)
				{
					System.Diagnostics.Debug.WriteLine("Connected!");
					String msg = "Hello! Type help for a list of available commands!";
					SendMassage(ref msg);
				}
			}
		}

		private void CheckForMassage(String str)
		{
			if (mClient.IsConnected)
			{
				void* buffer = Internal.Malloc(4096);

				if (mClient.Recv(buffer, 4096) case .Ok(let readSize))
				{
					if (readSize > 0)
					{
						String message = scope String((char8*)buffer, readSize);
						str.Clear();
						str.Append(message);
						Console.WriteLine(message);
					}
				}
				else
				{
					Console.WriteLine("Failed to receive data from socket");
				}
				Internal.Free(buffer);
			}
		}

		public void SendMassage(String msg, params System.Object[] arg)
		{
			String buffer = scope String()..AppendF(msg, params arg);
			SendMassage(ref buffer);
		}
		public void SendMassage(String msg)
		{
			var buffer = msg;
			SendMassage(ref buffer);
		}
		public void SendMassage(ref String msg)
		{
			bool hasNewLine = false;
			bool hasCR = false;
			for(int i < msg.Length)
			{
				char32 ch = msg[i];
				if(ch == '\n')
					hasNewLine = true;
				if(ch == '\r')
					hasCR = true;

				SendChar(ref ch);
			}

			if(!hasNewLine)
				SendChar('\n');
			if(!hasCR)
				SendChar('\r');

			System.Diagnostics.Debug.WriteLine("Send massage '{}'!", msg);
		}

		public void SendChar(char32 ch)
		{
			char32 buffer = ch;
			SendChar(ref buffer);
		}

		public void SendChar(ref char32 ch)
		{
			if(mClient.Send(&ch, sizeof(char32)) case .Ok)
			{
				System.Diagnostics.Debug.WriteLine("Send char '{}'!", ch);
			}
		}
	}
}
