-- https://github.com/lighttiger2505/sqls
local opts = {
  settings = {
    sqls = {
      connections = {
        {
          driver = 'mysql',
          dataSourceName = 'pskiadas:pskiadas123@/collegeDB',
          -- dataSourceName = 'pskiadas:pskiadas123@tcp(127.0.0.1:3306)/testdb',
          -- proto = 'tcp',
          -- user = 'pskiadas',
          -- passwd = 'pskiadas123',
          -- host = '127.0.0.1',
          -- port = '3306'
        },
      },
    },
  },
}

return opts
