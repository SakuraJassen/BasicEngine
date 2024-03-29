using SDL2;
using System;

namespace BasicEngine
{
	///*
	// Utility functions related to SDL and drawing.
	///*
	static class DrawUtils
	{
		///*
		// DrawString
		//   Draws a String to the provided SDL.Renderer.
		///*
		public static void DrawString(SDL.Renderer* r, Font font, float x, float y, String str, SDL.Color color, bool centerX = false)
		{
			var x;

			SDL.SetRenderDrawColor(r, 255, 255, 255, 255);
			let surface = SDLTTF.RenderUTF8_Blended(font.mFont, str, color);

			let texture = SDL.CreateTextureFromSurface(r, surface);
			SDL.Rect srcRect = .(0, 0, surface.w, surface.h);

			if (centerX)
				x -= surface.w / 2;

			SDL.Rect destRect = .((int32)x, (int32)y, surface.w, surface.h);
			SDL.RenderCopy(r, texture, &srcRect, &destRect);
			SDL.FreeSurface(surface);
			SDL.DestroyTexture(texture);
		}

		///*
		// DrawString
		//   Draws a String to the provided SDL.Renderer.
		///*
		public static Image GetStringImage(SDL.Renderer* r, Font font, float x, float y, String str, SDL.Color color, bool centerX = false)
		{
			var x;
			Image retImage = new Image();

			retImage.mSurface = SDLTTF.RenderUTF8_Blended(font.mFont, str, color);
			retImage.mTexture = SDL.CreateTextureFromSurface(r, retImage.mSurface);

			if (centerX)
				x -= retImage.mSurface.w / 2;

			return retImage;
		}

		///*
		// DrawStringOutline
		//   Draws a String with a given Outline thickness to the provided SDL.Renderer. (Quite Slow)
		///*
		public static void DrawStringOutline(SDL.Renderer* r, Font font, float x, float y, String str, SDL.Color color, int32 outlineSize = 1, bool centerX = false)
		{
			var x;

			SDL.SetRenderDrawColor(r, 255, 255, 255, 255);

			var fg_surface = SDLTTF.RenderUTF8_Blended(font.mFont, str, color);

			SDLTTF.SetFontOutline(font.mFont, outlineSize);
			let bg_surface = SDLTTF.RenderUTF8_Blended(font.mFont, str, SDL.Color(0, 0, 0, 255));
			SDLTTF.SetFontOutline(font.mFont, 0);

			SDL.SetSurfaceBlendMode(bg_surface, .Blend);
			SDL.Rect blitRect = .(outlineSize, outlineSize, bg_surface.w, bg_surface.h);
			SDL.SDL_BlitSurface(fg_surface, null, bg_surface, &blitRect);

			let texture = SDL.CreateTextureFromSurface(r, bg_surface);

			if (centerX)
				x -= bg_surface.w / 2;

			SDL.Rect destRect = .((int32)x, (int32)y, bg_surface.w, bg_surface.h);
			SDL.RenderCopy(r, texture, null, &destRect);

			SDL.FreeSurface(fg_surface);
			SDL.FreeSurface(bg_surface);
			SDL.DestroyTexture(texture);
		}

		public static Image GetStringOutlineImage(SDL.Renderer* r, Font font, float x, float y, String str, SDL.Color color, int32 outlineSize = 1, bool centerX = false)
		{
			var x;
			Image retImage = new Image();

			retImage.mSurface = SDLTTF.RenderUTF8_Blended(font.mFont, str, SDL.Color(0, 0, 0, 255));
			var fg_surface = SDLTTF.RenderUTF8_Blended(font.mFont, str, color);
			let bg_surface = retImage.mSurface;

			SDLTTF.SetFontOutline(font.mFont, outlineSize);
			SDLTTF.SetFontOutline(font.mFont, 0);

			SDL.SetSurfaceBlendMode(bg_surface, .Blend);
			SDL.Rect blitRect = .(outlineSize, outlineSize, bg_surface.w, bg_surface.h);
			SDL.SDL_BlitSurface(fg_surface, null, bg_surface, &blitRect);

			retImage.mTexture = SDL.CreateTextureFromSurface(r, retImage.mSurface);

			if (centerX)
				x -= bg_surface.w / 2;

			SDL.FreeSurface(bg_surface);

			return retImage;
		}

		///*
		// CreateTexture
		//    Creates a texture in the given Image Object
		///*
		// Params:
		//      image: the Image Object which stores the new Texture
		//       size: the size of the given texture
		//   renderer: the renderer with which the texture is created
		///*
		// Return:
		//   Results in Result.Err if the parameters are faulty.
		///*

		public static Result<void> CreateTexture(Image image, Size2D size, SDL.Renderer* renderer, SDL.TextureAccess textureAccess = .Target)
		{
			if (image == null)
				return .Err((.)"Image is null");

			if (size == null || (size.mX < 0 || size.mY < 0))
				return .Err((.)"Size is less then 0");

			if (renderer == null)
				return .Err((.)"Renderer is null");

			if (size.Width <= 0 || size.Height <= 0)
				return .Err((.)"Size can't be 0 ");

			if (image.mTexture != null)
			{
				SDL.DestroyTexture(image.mTexture);
				image.mTexture = null;
			}
			if (image.mSurface != null)
			{
				SDL.FreeSurface(image.mSurface);
				image.mSurface = null;
			}

			image.mSurface = SDL.CreateRGBSurfaceWithFormat(0, (.)size.Width, (.)size.Height, 32, (.)SDL.PIXELFORMAT_RGBA8888);
			if (image.mSurface == null)
			{
				SDLError!(1);
				return .Err((void)"Couldn't create Surface");
			}
			image.mTexture = SDL.CreateTexture(renderer, (.)SDL.PIXELFORMAT_RGBA8888, (.)textureAccess, (.)size.Width, (.)size.Height);
			if (image.mTexture == null)
			{
				SDLError!(1);
				return .Err((void)"Couldn't create Texture");
			}
			//SDL.SetTextureBlendMode(image.mTexture, SDL.BlendMode.Blend);
			image.mHeight = (int32)size.Height;
			image.mWidth = (int32)size.Width;
			return .Ok;
		}

		///*
		// DrawEllipse
		//    Draws a Ellipse on the given renderer.
		///*
		// Params:
		//   r: the renderer on which the Ellipse is drawn
		//   bounds: the bound in which the Ellipse should be drawn
		///*
		// Return:
		//   -
		///*
		public static void DrawEllipse(SDL.Renderer* r, SDL.Rect bounds)
		{
			int32 x0 = bounds.x;
			int32 y0 = bounds.y;
			int32 radiusX = bounds.w / 2;
			int32 radiusY = bounds.h / 2;

			float pi = Math.PI_f;
			float halfPi = pi / 2.0f;

			//drew  28 lines with   4x4  circle with precision of 150 0ms
			//drew 132 lines with  25x14 circle with precision of 150 0ms
			//drew 152 lines with 100x50 circle with precision of 150 3ms

			// precision value; value of 1 will draw a diamond, 27 makes pretty smooth circles.
			const int prec = 27;

			//starting point
			int32 x = (.)((float)radiusX * Math.Cos(0));
			int32 y = (.)((float)radiusY * Math.Sin(0));

			float stepSize = halfPi / (float)prec;
			//step through only a 90 arc (1 quadrant)
			for (float theta = stepSize; theta <= halfPi; theta += stepSize)
			{
				//get new point location
				int32 bufferX = (.)((float)radiusX * Math.Cos(theta) + 0.5f);//new point (+.5 is a quick rounding
				// method)
				int32 bufferY = (.)((float)radiusY * Math.Sin(theta) + 0.5f);

				//draw line from previous point to new point, ONLY if point incremented
				if ((x != bufferX) || (y != bufferY))
				{
					SDL.RenderDrawLine(r, x0 + x, y0 - y, x0 + bufferX, y0 - bufferY);//quadrant TR
					SDL.RenderDrawLine(r, x0 - x, y0 - y, x0 - bufferX, y0 - bufferY);//quadrant TL
					SDL.RenderDrawLine(r, x0 - x, y0 + y, x0 - bufferX, y0 + bufferY);//quadrant BL
					SDL.RenderDrawLine(r, x0 + x, y0 + y, x0 + bufferX, y0 + bufferY);//quadrant BR
				}

				//save previous points
				x = bufferX;
				y = bufferY;
			}

			//arc did not finish because of rounding, so finish the arc
			if (x != 0)
			{
				x = 0;
				SDL.RenderDrawLine(r, x0 + x, y0 - y, x0 + x, y0 - y);//quadrant TR
				SDL.RenderDrawLine(r, x0 - x, y0 - y, x0 - x, y0 - y);//quadrant TL
				SDL.RenderDrawLine(r, x0 - x, y0 + y, x0 - x, y0 + y);//quadrant BL
				SDL.RenderDrawLine(r, x0 + x, y0 + y, x0 + x, y0 + y);//quadrant BR
			}
		}

		[Inline]
		public static void SetPixel(uint32* data, Image image, int x, int y, SDL.Color color)
		{
			SDL.PixelFormat* fmt = image.mSurface.format;
			(data)[(image.mSurface.w) * y + x] = ((uint32)color.r << fmt.rshift | (uint32)color.g << fmt.gshift | (uint32)color.b << fmt.bshift) | (uint32)color.a;
		}

		[Inline]
		public static SDL.Color GetPixel(uint32* data, Image image, int x, int y)
		{
			SDL.Color color = .();
			SDL.PixelFormat* fmt = image.mSurface.format;
			var pixelVal = (data)[(image.mSurface.w) * y + x];
			color.a = (uint8)(pixelVal & fmt.Amask);
			color.r = (uint8)(pixelVal & fmt.Rmask);
			color.g = (uint8)(pixelVal & fmt.Gmask);
			color.b = (uint8)(pixelVal & fmt.Bmask);
			return color;
		}
	}
}
