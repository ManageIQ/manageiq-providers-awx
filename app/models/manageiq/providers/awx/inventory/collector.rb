class ManageIQ::Providers::Awx::Inventory::Collector < ManageIQ::Providers::Inventory::Collector
  def paginated_get(&block)
    all_results = []
    page = nil

    loop do
      results = block.call(page)
      all_results.concat(results.results)
      break if results._next.nil?

      # OpenAPI returns the entire path component for the next page so we have
      # to extract the integer page number.
      page = page_number_from_path(results._next)
    end

    all_results
  end

  def page_number_from_path(next_path)
    uri = URI(next_path)
    URI.decode_www_form(uri.query).to_h["page"]
  end
end
