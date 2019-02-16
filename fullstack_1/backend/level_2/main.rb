require 'json'
require 'date'

class Progress
    def initialize(id, objectiveId, value, date)
        @id = id
        @objectiveId = objectiveId
        @value = value
        @date = date
    end

    def value
        @value
    end
end

class Objectives
    def initialize(id, start, target, dateStart, dateEnd, progress)
        @id = id
        @start = start
        @target = target
        @progress = progress
        @dateStart = Date.parse(dateStart)
        @dateEnd = Date.parse(dateEnd)
        @numberOfDay = (@dateEnd - @dateStart).to_i
        @targetPerDay = (target > 0) ? target / @numberOfDay : 0
    end

    def progress
        @progress
    end

    def numberOfDay
        @numberOfDay
    end

    def getPercentage()
        return (@target > 0) ? @progress.value * (100 / @target) : 0
    end

    def getExcess()
        return (@targetPerDay > 0) ? @progress.value * (100 / @targetPerDay) : 0
    end
end

def getJSONData()
    file = File.open "data/input.json"
    
    return JSON.load(file)
end

def getProgressByObjectiveId(records, id)
    record = records.select{ |item|  item["objective_id"] == id}[0]

    return Progress.new(record["id"], record["objective_id"], record["value"], record["date"])
end

def createOutputJsonFile(results)
    json = {
        "progress_records" => results,
    }

    File.write("data/output.json",JSON.pretty_generate(json))
end

data = getJSONData()
objectives = data["objectives"]

outputs = []

objectives.each do |objective|
    progress = getProgressByObjectiveId(data["progress_records"], objective["id"])
  
    obj = Objectives.new(objective["id"], objective["start"], objective["target"],  objective["start_date"],  objective["end_date"], progress)

    puts obj.numberOfDay

    outputs << {
        "id" => objective["id"],
        "excess" => obj.getExcess()
    }
end

createOutputJsonFile(outputs)