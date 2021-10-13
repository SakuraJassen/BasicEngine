namespace BasicEngine.HUD
{
	class Formater
	{
		public int xOffset = 400;
		public int yOffset = 0;
		public int compWidth = 150;
		public int combHeight = 25;
		public int xPadding = 5;
		public int yPadding = 10;
		public int xMargin = 0;
		public int yMargin = 0;

		public int rowIndex = 0;
		public int columnIndex = 0;

		public this()
		{
		}

		public Vector2D GetNewPos()
		{
			Vector2D ret = new .(xOffset + ((compWidth + xPadding) * rowIndex) + xMargin, (yOffset + ((combHeight + yPadding) * columnIndex) + yMargin));
			return ret;
		}

		public void MoveTo(int row, int column)
		{
			rowIndex = row;
			columnIndex = column;
		}
	}
}
