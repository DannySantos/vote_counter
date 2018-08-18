def verify_line(arr)
  arr[2]&.include?("Campaign:") &&
  arr[3]&.include?("Validity:") &&
  arr[4]&.include?("Choice:") &&
  arr[4]&.split(":").count > 1 &&
  arr[5]&.include?("CONN:") &&
  arr[6]&.include?("MSISDN:") &&
  arr[7]&.include?("GUID:") &&
  arr[8]&.include?("Shortcode:")
end

desc "Parses vote data"
task :parse_votes, [:filepath] => :environment do |t, args|
  campaign_names, candidate_names, campaign_sql_values, candidate_sql_values = [], [], [], []
  votes = ""

  File.foreach(args.filepath) do |line|
    arr = line.encode('UTF-8', invalid: :replace, undef: :replace).split(" ")
    
    if verify_line(arr)
      campaign_name = arr[2].split(":")[1]
      candidate_name = arr[4].split(":")[1]
      validity = arr[3].split(":")[1]
      
      campaign_names << campaign_name
      candidate_names << candidate_name
      
      votes << "('#{campaign_name}', '#{candidate_name}', '#{validity}', '#{DateTime.now.strftime("%Y-%m-%d %H:%M:%S.%6N")}', '#{DateTime.now.strftime("%Y-%m-%d %H:%M:%S.%6N")}'), "
    end
  end
  
  campaign_names_existing = Campaign.pluck(:name)
  
  campaign_names.uniq.each do |campaign_name|
    campaign_sql_values << "('#{campaign_name}', '#{DateTime.now.strftime("%Y-%m-%d %H:%M:%S.%6N")}', '#{DateTime.now.strftime("%Y-%m-%d %H:%M:%S.%6N")}')" unless campaign_names_existing.include? campaign_name
  end
  
  candidate_names_existing = Candidate.pluck(:name)
  
  candidate_names.uniq.each do |candidate_name|
    candidate_sql_values << "('#{candidate_name}', '#{DateTime.now.strftime("%Y-%m-%d %H:%M:%S.%6N")}', '#{DateTime.now.strftime("%Y-%m-%d %H:%M:%S.%6N")}')" unless candidate_names_existing.include? candidate_name
  end
  
  campaigns_sql = "INSERT INTO campaigns (name, created_at, updated_at) VALUES #{campaign_sql_values.uniq.join(",")}"
  candidates_sql = "INSERT INTO candidates (name, created_at, updated_at) VALUES #{candidate_sql_values.uniq.join(",")}"
  
  campaigns_sql_sanitised = ActiveRecord::Base::sanitize_sql(campaigns_sql)
  candidates_sql_sanitised = ActiveRecord::Base::sanitize_sql(candidates_sql)
  
  ActiveRecord::Base.connection.execute(campaigns_sql_sanitised)
  ActiveRecord::Base.connection.execute(candidates_sql_sanitised)

  campaigns = Campaign.all
  candidates = Candidate.all
  
  votes_sql = "INSERT INTO votes (campaign_id, candidate_id, validity, created_at, updated_at) VALUES #{votes}"
  
  campaigns.each do |campaign|
    votes_sql.gsub!("'#{campaign.name}'", campaign.id.to_s)
  end
  
  candidates.each do |candidate|
    votes_sql.gsub!("'#{candidate.name}'", candidate.id.to_s)
  end
  
  votes_sql.gsub!("'during'", "0")
  votes_sql.gsub!("'pre'", "1")
  votes_sql.gsub!("'post'", "2")
  
  votes_sql_sanitised = ActiveRecord::Base::sanitize_sql(votes_sql)
  
  ActiveRecord::Base.connection.execute(votes_sql_sanitised.chomp(", "))
end
