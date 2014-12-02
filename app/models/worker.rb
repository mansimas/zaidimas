class Worker < ActiveRecord::Base
  HardWorker.perform_async
end