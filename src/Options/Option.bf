using System.IO;
using System;
using System.Collections;
namespace BasicEngine.Options
{
	class OptionsHandler
	{
		const String FILENAME = "options.ini";
		const String FILEPATH = "./";
		const String FILE = FILEPATH + FILENAME;

		public this()
		{
			if (!Directory.Exists(FILEPATH))
			{
				Directory.CreateDirectory(FILEPATH);
			}
			if (!File.Exists(FILE))
			{
				Create();
			}
		}

		public Result<void, FileOpenError> WriteOption(String varName, String val)
		{
			var fileStream = scope FileStream();

			if (fileStream.Open(FILE, FileMode.Create, FileAccess.Write, FileShare.ReadWrite) case .Err(let err))
				return .Err(err);

			fileStream.Write(StackStringFormat!("{}={}\n", varName, val));
			return .Ok;
		}

		public Result<StringView, FileOpenError> ReadOption<T>(String varName)
		{
			StreamReader sr = scope .();
			if (sr.Open(FILE) case .Err(let err))
				return .Err(err);
			for (var line in sr.Lines)
			{
				List<StringView> lbuffer = scope List<StringView>();
				for (var split in line.Value.Split('='))
				{
					lbuffer.Add(split);
				}

				if (lbuffer.Count != 2)
					continue;

				if (lbuffer[0] == varName)
				{
					return .Ok(lbuffer[1]);
				}
			}
			return .Err(.Unknown);
		}

		public Result<bool, FileOpenError> ExistOption(String varName)
		{
			StreamReader sr = scope .();
			if (sr.Open(FILE) case .Err(let err))
				return .Err(err);

			for (var line in sr.Lines)
			{
				if (line.Value.StartsWith(varName))
				{
					return .Ok(true);
				}
			}
			return .Ok(false);
		}

		public Result<void, FileOpenError> Create()
		{
			var fileStream = scope FileStream();
			if (!File.Exists(FILE))
			{
				File.Delete(FILE);
			}
			if (fileStream.Open(FILE, FileMode.Create, FileAccess.Write, FileShare.ReadWrite) case .Err(let err))
				return .Err(err);
			return .Ok;
		}
	}
}
