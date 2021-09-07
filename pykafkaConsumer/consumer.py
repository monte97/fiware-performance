from time import sleep
from json import loads
from kafka import KafkaConsumer

consumer = KafkaConsumer(
    'fiware-monitoring-montelli-1997',
     bootstrap_servers=['137.204.74.57:7777'],
     auto_offset_reset='earliest',
     enable_auto_commit=True,
     group_id='my-group-montelli',
     #value_deserializer=lambda x: loads(x.decode('utf-8'))
     )

print(consumer)

for message in consumer:
    if message.serialized_value_size > 10:
      print(message.offset)
      print(message.timestamp)
      print(message.value)
    else:
      print("funny")
    #print(message)
    #print(message.serialized_value_size)
    #message = message.value
    #print(message)
    print("_____")
