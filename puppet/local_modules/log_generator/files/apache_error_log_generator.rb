#!/usr/bin/ruby
 
class IPGenerator
  public
  def initialize(session_count, session_length)
    @session_count = session_count
    @session_length = session_length
 
    @sessions = {}
  end
 
  public
  def get_ip
    session_gc
    session_create
 
    ip = @sessions.keys[Kernel.rand(@sessions.length)]
    @sessions[ip] += 1
    return ip
  end
 
  private
  def session_create
    while @sessions.length < @session_count
      @sessions[random_ip] = 0
    end
  end
 
  private
  def session_gc
    @sessions.each do |ip, count|
      @sessions.delete(ip) if count >= @session_length
    end
  end
 
  private
  def random_ip
    octets = []
    octets << Kernel.rand(223) + 1
    3.times { octets << Kernel.rand(255) }
 
    return octets.join(".")
  end
end
 
 
class LogGenerator
 
  ERROR_MESSAGES = {
    "File does not exist: /home/httpd/twiki/view/Main/WebHome" => 1,
    "File does not exist: /usr/local/installed/apache/htdocs/pager/index.html" => 1,
    "File does not exist: /usr/local/installed/apache/htdocs/squirrelmail/_vti_bin/bin.exe/_vti_rpc" => 1,
    "File does not exist: /home/httpd/twiki/view/Main/Test" => 1,
    "File does not exist: /usr/local/installed/apache/htdocs/voicemail/index.html" => 1,
    "File does not exist: /usr/local/installed/apache/htdocs/squirrelmail/_vti_bin/sh.exe/_vti_rpc" => 1,
    "File does not exist: /home/httpd/twiki/view/Main/Teacher" => 1,
    "File does not exist: /usr/local/installed/apache/htdocs/main/page.html" => 1,
    "File does not exist: /usr/local/installed/apache/htdocs/squirrelmail/_vti_bin/tr.exe/_vti_rpc" => 1,
    "File does not exist: /home/httpd/twiki/view/Main/Inbox" => 1,
    "File does not exist: /usr/local/installed/apache/htdocs/test/page.html" => 1,
    "File does not exist: /usr/local/installed/apache/htdocs/squirrelmail/_vti_bin/ls.exe/_vti_rpc" => 1,
    "File does not exist: /home/httpd/twiki/view/Main/Outbox" => 1,
    "File does not exist: /usr/local/installed/apache/htdocs/cgi-bin/root.html" => 1,
    "File does not exist: /usr/local/installed/apache/htdocs/squirrelmail/_vti_bin/ln.exe/_vti_rpc" => 1,
    "File does not exist: /home/httpd/twiki/view/Main/NameNode" => 1,
    "File does not exist: /usr/local/installed/apache/htdocs/dom/nam.html" => 1,
    "File does not exist: /usr/local/installed/apache/htdocs/squirrelmail/_vti_bin/vi.exe/_vti_rpc" => 1,
    "File does not exist: /home/httpd/twiki/view/Main/pptp" => 1,
    "File does not exist: /usr/local/installed/apache/htdocs/test.html" => 1,
    "client denied by server configuration: /export/home/live/ap/htdocs" => 1,
    "client denied by server configuration: /export/home/live/ap/main" => 1,
    "client denied by server configuration: /export/home/live/ap/docs" => 1,
    "client denied by server configuration: /export/home/live/ap/null" => 1,
    "client denied by server configuration: /export/home/live/ap/main" => 1,
    "client denied by server configuration: /export/home/live/ap/pager" => 1,
    "client denied by server configuration: /export/home/live/ap/tickets" => 1,
    "client denied by server configuration: /export/home/live/ap/checkbox" => 1,
    "client denied by server configuration: /export/home/live/ap/trash" => 1,
    "client denied by server configuration: /export/home/live/ap/mail" => 1,
    "Client sent malformed Host header" => 5,
    "user test: authentication failure for /dcid/test1: Password Mismatch" => 1,
    "user test: authentication failure for /dcid/login: Password Mismatch" => 1,
    "user test: authentication failure for /dcid/docs: Password Mismatch" => 1,
    "user test: authentication failure for /dcid/main: Password Mismatch" => 1,
    "user test: authentication failure for /dcid/security: Password Mismatch" => 1,
    "Directory index forbidden by rule: /home/test/" => 1,
    "Directory index forbidden by rule: /home/main/" => 1,
    "Directory index forbidden by rule: /home/page1/" => 1,
    "Directory index forbidden by rule: /home/landingpage/" => 1,
    "Directory index forbidden by rule: /home/index/" => 1,
    "Directory index forbidden by rule: /home/site/" => 1,
    "Directory index forbidden by rule: /home/test/" => 1,
    "Directory index forbidden by rule: /home/httpd/" => 1,
    "Directory index forbidden by rule: /home/cgi-bin/" => 1,
    "Directory index forbidden by rule: /home/mor/" => 1,
    "caught SIGTERM, shutting down" => 2,
    "(11)Resource temporarily unavailable: fork: Unable to fork new process" => 10,
    "SIGHUP received.  Attempting to restart" => 3,
    "suEXEC mechanism enabled (wrapper: /usr/local/apache/sbin/suexec)" => 3,
    "pid file /opt/CA/BrightStorARCserve/httpd/logs/httpd.pid overwritten -- Unclean shutdown of previous Apache run?" => 2,
    "(104)Connection reset by peer: client stopped connection before send body completed" => 20,
    "statistics: Use of uninitialized value in concatenation (.) or string at /home/httpd/twiki/lib/TWiki.pm line 528." => 5,
    "statistics: Can't create file /home/httpd/twiki/data/Main/WebStatistics.txt - Permission denied" => 5
  }

  TYPES = {
    "error" => 73,
    "warning" => 27
  }
 
  public
  def initialize(ipgen)
    @ipgen = ipgen
  end
 

  public
  def write_qps(dest, qps)
    sleep = 1.0 / qps
    rows_inc = 1
    rows_limit = ARGV[0].to_i
    while ((rows_inc <= rows_limit) or (rows_limit == 0)) do
      write(dest, 1)
      sleep(sleep)
      rows_inc += 1
    end
  end
 
  public
  def write(dest, count)
    count.times do
      ip = @ipgen.get_ip
      err_msg = pick_weighted_key(ERROR_MESSAGES)
      date = Time.now.strftime("%d/%b/%Y:%H:%M:%S %z")
      type = pick_weighted_key(TYPES)
      dest.write("[#{date}] [#{type}] [client #{ip}] #{err_msg}\n")  
    end
  end
 
  private
  def pick_weighted_key(hash)
    total = 0
    hash.values.each { |t| total += t }
    random = Kernel.rand(total)
 
    running = 0
    hash.each do |key, weight|
      if random >= running and random < (running + weight)
        return key
      end
      running += weight
    end
 
    return hash.keys.first
  end
end
 
$stdout.sync = true
ipgen = IPGenerator.new(100, 10)
LogGenerator.new(ipgen).write_qps($stdout, 30)
