module DocumentablesHelper
  def documentable_class(documentable)
    documentable.class.name.parameterize(separator: "_")
  end

  def max_documents_allowed(documentable)
    documentable.class.max_documents_allowed
  end

  def max_file_size(documentable_class)
    documentable_class.max_file_size
  end

  def accepted_content_types(documentable_class)
    documentable_class.accepted_content_types
  end

  def accepted_content_types_extensions(documentable_class)
    Setting.accepted_content_types_for("documents").map { |content_type| ".#{content_type}" }.join(",")
  end

  def documentable_humanized_accepted_content_types(documentable_class)
    Setting.accepted_content_types_for("documents").join(", ")
  end

  def documentables_note(documentable)
    t "documents.form.note", max_documents_allowed: max_documents_allowed(documentable),
                             accepted_content_types: documentable_humanized_accepted_content_types(documentable.class),
                             max_file_size: max_file_size(documentable.class)
  end

  def max_documents_allowed?(documentable)
    documentable.documents.count >= documentable.class.max_documents_allowed
  end
end
