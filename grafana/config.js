define(['settings'],
function (Settings) {
  return new Settings({
    datasources: {
      elasticsearch: {
        type: 'elasticsearch',
        index: 'grafana-dash',
        url: '',
      },
      influx: {
        type: 'influxdb',
        default: true,
        grafanaDB: true,
        url: "INFLUXDB_URL/db/DB_NAME",
        username: "INFLUXDB_USER",
        password: "INFLUXDB_PASS",
      }
    },
    search: {
      max_results: 100
    },
    default_route: '/dashboard/file/default.json',
    grafana_index: "grafana-dash",
    unsaved_changes_warning: true,
    playlist_timespan: "1m",
    panel_names: ['text','graphite']
  });
});