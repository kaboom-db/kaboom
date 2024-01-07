class ImportWorker
  include Sidekiq::Worker

  def perform(klass:, comic_vine_id:)
    return "[IMPORT] Invalid resource type." unless klass.respond_to?(:import)
    resource = klass.import(comic_vine_id:)

    return "[IMPORT] #{klass} #{comic_vine_id} was not imported." unless resource.persisted?
    return "[IMPORT] #{klass} #{comic_vine_id} was successfully imported." unless resource.respond_to?(:import_issues)

    resource.import_issues

    "[IMPORT] #{klass} #{comic_vine_id} was successfully imported with its issues."
  end
end
