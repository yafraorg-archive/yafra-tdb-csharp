using System;
using System.IO;

namespace org.swyn.foundation.utils
{
	#region Interface definition
	interface ISwynLog
	{
		void Init(bool a, bool b);
		void Debug(string a);
		void LogFile(string a);
		void LogEvent(string a);
		void Close();
	}
	#endregion

	/// <summary>
	/// Logging and debugging class, supports console, files, eventlogs.
	/// </summary>
	public class Log : ISwynLog
	{
		static private bool _debugFlag = false;
		static private bool _cons = false;
		static private string _applicationName;
		static private string _logpath = @"C:\TEMP\";
		static private string _logfile = "TDB_log.txt";
		static private string _dbgfile = "TDB_debug.txt";
		static private Stream _slog;
		static private Stream _sdebug;
		static private TextWriter _slogW;
		static private TextWriter _sdebugW;

		public Log()
		{
			//
			// TODO: Add constructor logic here
			//
		}


		#region Get and Set flags and vars
		public bool IsDebug
		{
			get
			{
				return _debugFlag;
			}
		}
		public bool IsConsole
		{
			get
			{
				return _cons;
			}
		}
		#endregion

		#region Methods
		public void Init(bool Adbg, bool Acons)
		{
			// init filename to open
			string tmplog, tmpdbg;
			tmplog = String.Format("{0}{1}", _logpath, _logfile);
			tmpdbg = String.Format("{0}{1}", _logpath, _dbgfile);

			// set flags
			_cons = Acons;
			_debugFlag = Adbg;

			// check to see if we need files or console writes
			if (!_cons)
			{
				_slog = File.OpenWrite(tmplog);
				_slogW = new StreamWriter(_slog);
				if (_debugFlag)
				{
					_sdebug = File.OpenWrite(tmpdbg);
					_sdebugW = new StreamWriter(_sdebug);
				}
			}

			// write init message with apps name
			if (_cons)
			{
				Console.WriteLine("travelDB logging init\n\n");
				if (_debugFlag)
					Console.WriteLine("travelDB debugging init\n\n");
			}
			else
			{
				_slogW.WriteLine("travelDB logging init\n\n");			
				if (_debugFlag)
					_sdebugW.WriteLine("travelDB debugging init\n\n");			
			}
		}
		public void Close()
		{
			if (!_cons)
			{
				// write close message with apps name
				_slogW.WriteLine("travelDB logging init\n\n");			
				_slogW.Close();
				_slog.Close();
				if (_debugFlag)
				{
					_sdebugW.WriteLine("travelDB debugging init\n\n");			
					_sdebugW.Close();
					_sdebug.Close();
				}
			}
		}
		public void Debug(string Amsg)
		{
			if (_debugFlag)
			{
				if (_cons)
					Console.WriteLine("debug: {0}", Amsg);
				else
					_sdebugW.WriteLine("debug: {0}", Amsg);
			}
		}
		public void LogFile(string Amsg)
		{
			if (_cons)
				Console.WriteLine("logging: {0}", Amsg);
			else
				_slogW.WriteLine("logging: {0}", Amsg);
		}
		public void LogEvent(string Amsg)
		{
		}
		#endregion
	}
}
