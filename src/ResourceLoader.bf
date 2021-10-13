using System;
using SDL2;
using System.Collections;

namespace BasicEngine
{
	static class ResourceLoader
	{
		static Dictionary<String, Image> sImages = new Dictionary<String, Image>() ~ DeleteDictionaryAndKeysAndValues!(_); //With alot Resources this will get quite slow

		public static Result<Image> LoadTexture(String fileName)
		{
			if(sImages.ContainsKey(fileName))
			{
				//Log!(StackStringFormat!("Fetching File from RAM: {}", fileName));
				return sImages[fileName];
			}
				
			Image image = new Image();
			if (image.Load(fileName) case .Err)
			{
				Log!(scope $"Couldn't open File: {fileName}");
				delete image;
				return .Err;
			}

			Log!(StackStringFormat!("Fetching File from DISK: {}", fileName));

			String file = ToGlobalString!(fileName);
			sImages.Add(file, image);

			return image;
		}
	}
}
