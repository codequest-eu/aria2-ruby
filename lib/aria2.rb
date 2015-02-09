require 'aria2/version'
require 'rest_client'

module Aria2

  class Downloader

    require 'open-uri'
    require 'json'
    require 'base64'
    require 'cgi'
    require 'net/http'

    def initialize(params)
      @host = params[:host] || 'localhost'
      @port = params[:port] || 6800
      @token = params[:token] || ''
    end

    def check
      rpc('getGlobalStat', [])
    end

    def remove(gid)
      rpc('remove', [gid])
    end

    def forceRemove(gid)
      rpc('forceRemove', [gid])
    end

    def pause(gid)
      rpc('pause', [gid])
    end

    def pauseAll()
      rpc('pauseAll', [])
    end

    def forcePause(gid)
      rpc('forcePause', [gid])
    end

    def forcePauseAll()
      rpc('forcePauseAll', [])
    end

    def unPause(gid)
      rpc('unPause', [gid])
    end

    def unPauseAll()
      rpc('unPauseAll', [])
    end

    def getUris(gid)
      rpc('getUris', [gid])
    end

    def getFiles(gid)
      rpc('getFiles', [gid])
    end

    def getPeers(gid)
      rpc('getPeers', [gid])
    end

    def getServers(gid)
      rpc('getServers', [gid])
    end

    def getOption(gid)
      rpc('getOption', [gid])
    end

    def changeOption(gid, options)
      rpc('changeOption', [gid, options])
    end

    def purgeDownloadResult()
      rpc('purgeDownloadResult')
    end

    def removeDownloadResult(gid)
      rpc('removeDownloadResult', [gid])
    end

    def getVersion()
      rpc('getVersion', [])
    end

    def getSessionInfo()
      rpc('getSessionInfo', [])
    end

    def shutdown()
      rpc('shutdown', [])
    end

    def forceShutdown()
      rpc('forceShutdown', [])
    end

    def saveSession()
      rpc('saveSession', [])
    end

    def addTorrent(torrent)
      rpc('addTorrent', [torrent])
    end

    def addTorrentFile(filename)
      torrent = Base64.encode64(File.open(filename, "rb").read)
      addTorrent(torrent)
    end

    def getActive()
      rpc('tellActive', [])
    end

    def query_status(gid)
      status = rpc('tellStatus', [gid, [
                                         'status',
                                         'totalLength',
                                         'completedLength',
                                         'downloadSpeed',
                                         'errorCode',
                                         'infoHash',
                                         'numSeeders'
                                     ]])

      status['totalLength'] = status['totalLength'].to_i
      status['completedLength'] = status['completedLength'].to_i
      status['downloadSpeed'] = status['downloadSpeed'].to_i
      status['errorCode'] = status['errorCode'].to_i
      status['infoHash'] = status['infoHash']
      status['numSeeders'] = status['numSeeders'].to_i

      status['progress'] = status['totalLength'] == 0 ?
          0 :
          status['completedLength'].to_f / status['totalLength'].to_f

      status['remainingTime'] = status['downloadSpeed'] == 0 ?
          0 :
          (status['totalLength'] - status['completedLength']).to_f / status['downloadSpeed']

      status
    end

    private

    def post(url, params = {})
      uri = URI.parse(url)
      response = RestClient.post(url, params.to_json, :content_type => :json, :accept => :json)
      {
          'code' => response.code.to_i,
          'body' => response.body
      }
    end

    def rpc_path
      "http://#{@host}:#{@port}/jsonrpc"
    end

    def rpc(method, params)
      method = "aria2.#{method}"
      id = 'ruby-aria2'
      params_encoded = params #Base64.encode64(JSON.generate(params))
      if @token != '' then
        response = post("#{rpc_path}", {'token' => @token, 'method' => method, 'id' => id, 'params' => params_encoded})
      else
        response = post("#{rpc_path}", {'method' => method, 'id' => id, 'params' => params_encoded})
      end
      answer = JSON.parse(response['body'])

      if response['code'] == 200
        answer['result']
      else
        raise "AriaDownloader error #{answer['error']['code'].to_i}: #{answer['error']['message']}"
      end
    end

  end

end

