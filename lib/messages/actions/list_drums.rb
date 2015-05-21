module Messages::Actions::ListDrums

  def list_drums(args)
    return {
      response: 'success',
      display: drum_list
    }
  end

  def drum_list
    result = ''
    names = Pattern.all.select{|x|x.purpose == 'event'}.collect{|x|x.name}
    names.each {|x| result << "* #{x}\n"}
    return result
  end

end
