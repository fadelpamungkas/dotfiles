return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		{ "tpope/vim-dadbod" },
		{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" } },
	},
	cmd = {
		"DBUI",
		"DBUIToggle",
		"DBUIAddConnection",
		"DBUIFindBuffer",
	},
	init = function()
		-- Your DBUI configuration
		vim.g.db_ui_auto_execute_table_helpers = 1
		vim.g.db_ui_use_nvim_notify = 1
		vim.g.dbs = {
			{ name = "dev", url = "postgres://postgres:mypassword@localhost:5432/my-dev-db" },
			{ name = "staging", url = "postgres://postgres:mypassword@localhost:5432/my-staging-db" },
			{ name = "invoice", url = "mysql://root@localhost/invoice" },
			{ name = "public_video", url = "sqlite:/Users/fadel/GoProjects/frud-serv-main/test.db" },
			{ name = "local_redis", url = "redis://localhost:6379" },
			{ name = "local_mongodb", url = "mongodb://localhost:27017" },
		}
		vim.g.db_ui_table_helpers = {
			postgresql = {
				Count = "SELECT COUNT(*) FROM {table}",
				Explain = "EXPLAIN ANALYZE {last_query}",
			},
			sqlite = {
				Count = "SELECT COUNT(*) FROM {table}",
				Explain = "EXPLAIN QUERY PLAN {last_query}",
			},
			redis = {
				Count = "DBSIZE",
				Keys = "KEYS *",
				ClearAll = "FLUSHALL",
			},
      mongodb = {
        Count = "db.{table}.count()",
        Find = "db.{table}.find()",
        FindOne = "db.{table}.findOne()",
        FindById = "db.{table}.findOne(ObjectId('{id}'))",
        Insert = "db.{table}.insert({document})",
        Update = "db.{table}.update({query}, {update})",
        Delete = "db.{table}.remove({query})",
      },
		}
	end,
}
