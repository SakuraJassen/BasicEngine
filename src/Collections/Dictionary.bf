using System.Collections;

namespace BasicEngine.Collections.Dictionarys
{
	class Dictionary
	{
		DictionaryItem mStartEntry = new DictionaryItem('\0');
		this()
		{

		}
	}

	class DictionaryItem
	{
		DictionaryItem[] subChars = new DictionaryItem[26];
		private int mSubEntrys = 0;
		public int SubEntrys
		{
			get
			{
				return mSubEntrys;
			}
		}

		private char8 mChar = '\0';
		public char8 Char
		{
			get
			{
				return mChar;
			}
		}

		public this(char8 ch) {
			mChar = ch;
		}
	}
}
