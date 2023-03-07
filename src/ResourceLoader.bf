using System;
using SDL2;
using System.Collections;
using BasicEngine.Debug;

namespace BasicEngine
{
	static class ResourceLoader
	{
		static Dictionary<String, Image> sImages = new Dictionary<String, Image>() ~ DeleteDictionaryAndKeysAndValues!(_);
		// With alot of Resources this will get quite slow

		public static Result<Image> LoadTexture(String fileName)
		{
			Image image = null;
			if (sImages.TryGetValue(fileName, out image))
			{
				//Log!(StackStringFormat!("Fetching File from RAM: {}", fileName));
				return image;
			}

			image = new Image();
			if (image.Load(fileName) case .Err)
			{
				Logger.Error(scope $"Couldn't open File: {fileName}");
				delete image;
				return .Err;
			}

			Logger.Info(StackStringFormat!("Fetching File from DISK: {}", fileName));

			String file = ToGlobalString!(fileName);
			sImages.Add(file, image);

			return image;
		}


	}
}
