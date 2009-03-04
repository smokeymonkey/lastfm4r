class Lastfm4r
  require 'net/http'
  require 'rexml/document'
  require 'kconv'
  $KCODE="UTF8"

  @@uri = URI.parse('http://ws.audioscrobbler.com/2.0/')

  def initialize
    @user=nil
    @api_key=nil
  end

  def user(userid,apikey)
    @user = userid
    @api_key = apikey
  end

  def getrecenttracks
    return analyzeXML("user.getrecenttracks","/lfm/recenttracks/track","artist,name,url,album,date,streamable")
  end

  def getfriends
    return analyzeXML("user.getfriends","/lfm/friends/user","name,url")
  end

  def getshouts
    return analyzeXML("user.getshouts","/lfm/shouts/shout","body,author,date")
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
