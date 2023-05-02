import Config

config :brod,
  clients: [
    brod_client: [
      endpoints: [
        {'localhost', 29092}
      ],
      ssl: false
    ]
  ]

config :kafex,
  echo_subscriber: [
    enabled: true,
    topic: "test-satya",
    consumer_group: "echogroup-v2"
  ],
  satya_subscriber: [
    enabled: true,
    topic: "test-satya",
    consumer_group: "satyagroup-v2"
  ]
