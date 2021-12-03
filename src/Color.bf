using SDL2;
using System;
namespace BasicEngine
{
	public class Color
	{
		public uint8 R = (.)255;
		public uint8 G = (.)255;
		public uint8 B = (.)255;

		public bool IsWhite { get { return R == 0xFF && G == 0xFF && B == 0xFF; } };
		public bool IsBlack { get { return R == 0x00 && G == 0x00 && B == 0x00; } };

		///*
		// this
		//    the Constructor calls SetColor with the given Parameters
		///*
		public this()
		{
		}

		public this(uint8 r, uint8 g, uint8 b)
		{
			SetColor(r, g, b);
		}

		public this(Color col)
		{
			SetColor(col);
		}

		public void SetColor(Color col)
		{
			SetColor(col.R, col.G, col.B);
		}

		public void SetColor(uint8 r, uint8 g, uint8 b)
		{
			this.R = r;
			this.G = g;
			this.B = b;
		}

		public void SetRandom()
		{
			SetColor((.)gRand.Next(0x00, 0xFF), (.)gRand.Next(0x00, 0xFF), (.)gRand.Next(0x00, 0xFF));
		}
		public void SetRandomNotPure()
		{
			SetColor((.)gRand.Next(0x01, 0xFE), (.)gRand.Next(0x01, 0xFE), (.)gRand.Next(0x01, 0xFE));
		}
		public void SetRandom(((int, int), (int, int), (int, int)) range)
		{
			SetColor((.)gRand.Next(range.0.0, range.0.1), (.)gRand.Next(range.1.0, range.1.1), (.)gRand.Next(range.2.0, range.2.1));
		}

		public SDL.Color ToSDLColor()
		{
			return SDL.Color(R, G, B, 255);
		}
	}
}
