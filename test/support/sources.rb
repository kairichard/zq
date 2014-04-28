class TestSource
  def transactional?
    false
  end

  def initialize(contents)
    @contents = contents
  end

  def read_next
    @contents.shift
  end
end


