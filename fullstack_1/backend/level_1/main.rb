require 'json'

class Progress
    def initialize(id, objectiveId, value)
        @id = id
        @objectiveId = objectiveId
        @value = value
    end

    def value
        @value
    end
end

class Objectives
    def initialize(id, start, target, progress)
        @id = id
        @start = start
        @target = target
        @progress = progress
    end

    def progress
        @progress
    end

    def getPercentage()
        if(@target == 0)
            return 0;
        end

        return @progress.value * (100 / @target)
    end
end

def getJSONData()
    file = File.open "data/input.json"
    
    return JSON.load(file)
end

def getProgressByObjectiveId(records, id)
    record = records.select{ |item|  item["objective_id"] == id}[0]

    return Progress.new(record["id"], record["objective_id"], record["value"])
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
  
    obj = Objectives.new(objective["id"], objective["start"], objective["target"], progress)

    outputs << {
        "id" => objective["id"],
        "progress" => obj.getPercentage()
    }
end

createOutputJsonFile(outputs)