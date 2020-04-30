{
  prometheusEtcdRules+:: {
    groups+: [
      {
        name: 'etcd.rules',
        rules: [
          {
            record: 'etcd:up:sum',
            expr: |||
              sum(up{%(etcdSelector)s} == 1)
            ||| % $._config,
          },
          {
            record: 'etcd:etcd_server_leader_changes_seen:sum_changes',
            expr: |||
              sum(label_replace(sum(changes(etcd_server_leader_changes_seen_total{%(etcdSelector)s}[1h])) by (instance), "node", "$1", "instance", "(.*):.*")) by (node)
            ||| % $._config,
          },
          {
            record: 'etcd:etcd_server_proposals_failed:sum_irate',
            expr: |||
              sum(label_replace(sum(irate(etcd_server_proposals_failed_total{%(etcdSelector)s}[5m])) by (instance), "node", "$1", "instance", "(.*):.*")) by (node)
            ||| % $._config,
          },
          {
            record: 'etcd:etcd_server_proposals_applied:sum_irate',
            expr: |||
              sum(label_replace(sum(irate(etcd_server_proposals_applied_total{%(etcdSelector)s}[5m])) by (instance), "node", "$1", "instance", "(.*):.*")) by (node)
            ||| % $._config,
          },
          {
            record: 'etcd:etcd_server_proposals_committed:sum_irate',
            expr: |||
              sum(label_replace(sum(irate(etcd_server_proposals_committed_total{%(etcdSelector)s}[5m])) by (instance), "node", "$1", "instance", "(.*):.*")) by (node)
            ||| % $._config,
          },
          {
            record: 'etcd:etcd_server_proposals_pending:sum',
            expr: |||
              sum(label_replace(sum(etcd_server_proposals_pending{%(etcdSelector)s}) by (instance), "node", "$1", "instance", "(.*):.*")) by (node)
            ||| % $._config,
          },
          {
            record: 'etcd:etcd_debugging_mvcc_db_total_size:sum',
            expr: |||
              sum(label_replace(etcd_debugging_mvcc_db_total_size_in_bytes{%(etcdSelector)s},"node", "$1", "instance", "(.*):.*")) by (node)
            ||| % $._config,
          },
          {
            record: 'etcd:etcd_mvcc_db_total_size:sum',
            expr: |||
              sum(label_replace(etcd_mvcc_db_total_size_in_bytes{%(etcdSelector)s},"node", "$1", "instance", "(.*):.*")) by (node)
            ||| % $._config,
          },
          {
            record: 'etcd:etcd_network_client_grpc_received_bytes:sum_irate',
            expr: |||
              sum(label_replace(sum(irate(etcd_network_client_grpc_received_bytes_total{%(etcdSelector)s}[5m])) by (instance), "node", "$1", "instance", "(.*):.*")) by (node)
            ||| % $._config,
          },
          {
            record: 'etcd:etcd_network_client_grpc_sent_bytes:sum_irate',
            expr: |||
              sum(label_replace(sum(irate(etcd_network_client_grpc_sent_bytes_total{%(etcdSelector)s}[5m])) by (instance), "node", "$1", "instance", "(.*):.*")) by (node)
            ||| % $._config,
          },
          {
            record: 'etcd:grpc_server_started:sum_irate',
            expr: |||
              sum(label_replace(sum(irate(grpc_server_started_total{%(etcdSelector)s,grpc_type="unary"}[5m])) by (instance), "node", "$1", "instance", "(.*):.*")) by (node)
            ||| % $._config,
          },
          {
            record: 'etcd:grpc_server_handled:sum_irate',
            expr: |||
              sum(label_replace(sum(irate(grpc_server_handled_total{%(etcdSelector)s,grpc_type="unary",grpc_code!="OK"}[5m])) by (instance), "node", "$1", "instance", "(.*):.*")) by (node)
            ||| % $._config,
          },
          {
            record: 'etcd:grpc_server_msg_received:sum_irate',
            expr: |||
              sum(label_replace(sum(irate(grpc_server_msg_received_total{%(etcdSelector)s}[5m])) by (instance), "node", "$1", "instance", "(.*):.*")) by (node)
            ||| % $._config,
          },
          {
            record: 'etcd:grpc_server_msg_sent:sum_irate',
            expr: |||
              sum(label_replace(sum(irate(grpc_server_msg_sent_total{%(etcdSelector)s}[5m])) by (instance), "node", "$1", "instance", "(.*):.*")) by (node)
            ||| % $._config,
          },
          {
            record: 'etcd:etcd_disk_wal_fsync_duration:avg',
            expr: |||
              sum(label_replace(sum(irate(etcd_disk_wal_fsync_duration_seconds_sum{%(etcdSelector)s}[5m])) by (instance) / sum(irate(etcd_disk_wal_fsync_duration_seconds_count{%(etcdSelector)s}[5m])) by (instance), "node", "$1", "instance", "(.*):.*")) by (node)
            ||| % $._config,
          },
          {
            record: 'etcd:etcd_disk_backend_commit_duration:avg',
            expr: |||
              sum(label_replace(sum(irate(etcd_disk_backend_commit_duration_seconds_sum{%(etcdSelector)s}[5m])) by (instance) / sum(irate(etcd_disk_backend_commit_duration_seconds_count{%(etcdSelector)s}[5m])) by (instance), "node", "$1", "instance", "(.*):.*")) by (node)
            ||| % $._config,
          },
        ],
      },
      {
        name: 'etcd_histogram.rules',
        rules: [
          {
            record: 'etcd:%s:histogram_quantile' % metric,
            expr: |||
              histogram_quantile(%(quantile)s, sum(label_replace(sum(irate(%(metric)s_seconds_bucket{%(etcdSelector)s}[5m])) by (instance, le), "node", "$1", "instance", "(.*):.*")) by (node, le))
            ||| % ({ quantile: quantile, metric: metric } + $._config),
            labels: {
              quantile: quantile,
            },
          }
          for metric in ['etcd_disk_wal_fsync_duration', 'etcd_disk_backend_commit_duration']
          for quantile in ['0.99', '0.9', '0.5']
        ],
      },
    ],
  },
}
