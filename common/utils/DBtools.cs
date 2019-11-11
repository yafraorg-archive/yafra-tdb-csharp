using System;
using System.Data;
using org.swyn.foundation.db;

namespace org.swyn.foundation.utils
{
	/// <summary>
	/// Easy SQL functions.
	/// </summary>
	public class DBtools
	{
		private AdoHelper _dbhelper;
		private string _dbcon;
		private IDbConnection _con;
		private IDbTransaction _tran;

		public DBtools(AdoHelper Ahlp, string Adbcon)
		{
			//
			// TODO: Add constructor logic here
			//
			_dbhelper = Ahlp;
			_dbcon = Adbcon;
			_con = _dbhelper.GetConnection(_dbcon);

			// begin transaction here
		}
		public void BeginTrx()
		{
			// con.Open();
			// tran = con.BeginTransaction();
		}
		public void Commit()
		{
			// tran.Commit();
		}
		public void Rollback()
		{
			// tran.Rollback();
		}
		public int NewId(string Atable, string Aidname)
		{
			string sql;
			sql = String.Format("select MAX({0}) from tdbadmin.{1}", Aidname, Atable);
			int newid = (int)_dbhelper.ExecuteScalar(_dbcon, CommandType.Text, sql);
			if (newid < 0)
				newid = 0;
			newid++;
			return newid;
		}
		public int DBcmd(string Acmd)
		{
			int affrows = (int)_dbhelper.ExecuteNonQuery(_dbcon, CommandType.Text, Acmd);
			return affrows;
		}
		public void FillDs(DataSet Ads, string Asql, string[] Atabs)
		{
			_dbhelper.FillDataset(_dbcon, CommandType.Text, Asql, Ads, Atabs );
		}
		public void UpdDs(DataSet Ads, string Aicmd, string [] Aiarg, string Aucmd, string [] Auarg, string Adcmd, string [] Adarg, string Atabs)
		{
			IDbCommand inscmd = _dbhelper.CreateCommand(_con, Aicmd, Aiarg);
			IDbCommand updcmd = _dbhelper.CreateCommand(_con, Aucmd, Auarg);
			IDbCommand delcmd = _dbhelper.CreateCommand(_con, Adcmd, Adarg);
			_dbhelper.UpdateDataset(inscmd, delcmd, updcmd, Ads, Atabs);
		}
	}
}
