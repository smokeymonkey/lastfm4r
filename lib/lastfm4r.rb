class Lastfm4r
  require 'net/http'
  require 'rexml/document'

  @@uri = URI.parse('http://ws.audioscrobbler.com/2.0/')

  def initialize
    @user=nil
    @api_key=nil
  end

  def user(userid,apikey)
    @user = userid
    @api_key = apikey
  end

  def getfriends
    return analyzeXML("user.getfriends","/lfm/friends/user","name,url")
  end
  
  def getlovedtracks
    return analyzeXML("user.getlovedtracks","/lfm/lovedtracks/track","name,url,date,artist/name,artist/url")
  end

  def getneighbours
    return analyzeXML("user.getneighbours","/lfm/neighbours/user","name,url,image,match")
  end

  def getplaylists
    return analyzeXML("user.getplaylists","/lfm/playlists/playlist","id,title,description,date,size,duration,streamable,creator,url")
  end

  def getrecenttracks
    return analyzeXML("user.getrecenttracks","/lfm/recenttracks/track","artist,name,url,album,date,streamable")
  end

  def getshouts
    return analyzeXML("user.getshouts","/lfm/shouts/shout","body,author,date")
  end

  def gettopalbums
    return analyzeXML("user.gettopalbums","/lfm/topalbums/album","name,playcount,url,artist/name,artist/url")
  end

  def gettopartists
    return analyzeXML("user.gettopartists","/lfm/topartists/artist","name,playcount,url,streamable")
  end

  def gettoptags
    return analyzeXML("user.gettoptags","/lfm/toptags/tag","name,count,url")
  end

  def gettoptracks
    return analyzeXML("user.gettoptracks","/lfm/toptracks/track","name,playcount,url,streamable,artist/name,artist/url")
  end

  def getweeklyalbumchart
    return analyzeXML("user.getweeklyalbumchart","/lfm/weeklyalbumchart/album","artist,name,playcount,url")
  end

  def getweeklyartistchart
    return analyzeXML("user.getweeklyartistchart","/lfm/weeklyartistchart/artist","name,playcount,url")
  end

  def getweeklytrackchart
    return analyzeXML("user.getweeklytrackchart","/lfm/weeklytrackchart/track","artist,name,playcount,url")
  end

  def analyzeXML(mthd,elements,ename)
    method = mthd
    elms = elements
    enames = ename.split(",")

    alist = Array.new
    rlist = Array.new

    query = "method=" + method + "&user=" + @user + "&api_key=" + @api_key
    xml = Net::HTTP.start(@@uri.host){|http|http.post(@@uri.path,query)}.body
    doc = REXML::Document.new xml
    doc.elements.each(elms) do |elm|
      enames.each do |ename|
        alist << [ename,elm.elements[ename].text]
      end
      rlist << [Hash[*alist.flatten]]
    end
    return rlist
  end
end
