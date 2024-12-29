table "user" {
  schema = schema.public

  column "id" {
    type = uuid
    null = false
  }

  column "email" {
    type = text
    null = false
  }

  column "name" {
    type = text
    null = false
  }

  column "avatar_url" {
    type = text
    null = true
  }

  column "role" {
    type = text
    null = false
  }

  column "created_at" {
    type = timestamptz
    null = false
    default = sql("now()")
  }

  column "updated_at" {
    type = timestamptz
    null = false
    default = sql("now()")
  }

  primary_key {
    columns = [column.id]
  }

  index "user_email_idx" {
    columns = [column.email]
    unique = true
  }
}

table "enterprise" {
  schema = schema.public

  column "id" {
    type = uuid
    null = false
  }

  column "name" {
    type = text
    null = false
  }

  column "slug" {
    type = text
    null = false
  }

  column "created_at" {
    type = timestamptz
    null = false
    default = sql("now()")
  }

  column "updated_at" {
    type = timestamptz
    null = false
    default = sql("now()")
  }

  primary_key {
    columns = [column.id]
  }

  index "enterprise_slug_idx" {
    columns = [column.slug]
    unique = true
  }
}

table "workspace" {
  schema = schema.public

  column "id" {
    type = uuid
    null = false
  }

  column "name" {
    type = text
    null = false
  }

  column "slug" {
    type = text
    null = false
  }

  column "enterprise_id" {
    type = uuid
    null = true
  }

  column "created_at" {
    type = timestamptz
    null = false
    default = sql("now()")
  }

  column "updated_at" {
    type = timestamptz
    null = false
    default = sql("now()")
  }

  primary_key {
    columns = [column.id]
  }

  foreign_key "workspace_enterprise_id_fk" {
    columns = [column.enterprise_id]
    ref_columns = [table.enterprise.column.id]
    on_delete = CASCADE
  }

  index "workspace_slug_idx" {
    columns = [column.slug]
    unique = true
  }
}

table "area" {
  schema = schema.public

  column "id" {
    type = uuid
    null = false
  }

  column "name" {
    type = text
    null = false
  }

  column "slug" {
    type = text
    null = false
  }

  column "workspace_id" {
    type = uuid
    null = false
  }

  column "created_at" {
    type = timestamptz
    null = false
    default = sql("now()")
  }

  column "updated_at" {
    type = timestamptz
    null = false
    default = sql("now()")
  }

  primary_key {
    columns = [column.id]
  }

  foreign_key "area_workspace_id_fk" {
    columns = [column.workspace_id]
    ref_columns = [table.workspace.column.id]
    on_delete = CASCADE
  }

  index "area_workspace_slug_idx" {
    columns = [column.workspace_id, column.slug]
    unique = true
  }
}

table "area_member" {
  schema = schema.public

  column "id" {
    type = uuid
    null = false
  }

  column "area_id" {
    type = uuid
    null = false
  }

  column "user_id" {
    type = uuid
    null = false
  }

  column "role" {
    type = text
    null = false
    default = "member"
  }

  column "created_at" {
    type = timestamptz
    null = false
    default = sql("now()")
  }

  column "updated_at" {
    type = timestamptz
    null = false
    default = sql("now()")
  }

  primary_key {
    columns = [column.id]
  }

  foreign_key "area_member_area_id_fk" {
    columns = [column.area_id]
    ref_columns = [table.area.column.id]
    on_delete = CASCADE
  }

  foreign_key "area_member_user_id_fk" {
    columns = [column.user_id]
    ref_columns = [table.user.column.id]
    on_delete = CASCADE
  }

  index "area_member_area_user_idx" {
    columns = [column.area_id, column.user_id]
    unique = true
  }
}

table "workspace_member" {
  schema = schema.public

  column "id" {
    type = uuid
    null = false
  }

  column "workspace_id" {
    type = uuid
    null = false
  }

  column "user_id" {
    type = uuid
    null = false
  }

  column "role" {
    type = text
    null = false
    default = "member"
  }

  column "created_at" {
    type = timestamptz
    null = false
    default = sql("now()")
  }

  column "updated_at" {
    type = timestamptz
    null = false
    default = sql("now()")
  }

  primary_key {
    columns = [column.id]
  }

  foreign_key "workspace_member_workspace_id_fk" {
    columns = [column.workspace_id]
    ref_columns = [table.workspace.column.id]
    on_delete = CASCADE
  }

  foreign_key "workspace_member_user_id_fk" {
    columns = [column.user_id]
    ref_columns = [table.user.column.id]
    on_delete = CASCADE
  }

  index "workspace_member_workspace_user_idx" {
    columns = [column.workspace_id, column.user_id]
    unique = true
  }
}

table "project" {
  schema = schema.public

  column "id" {
    type = uuid
    null = false
  }

  column "name" {
    type = text
    null = false
  }

  column "description" {
    type = text
    null = true
  }

  column "slug" {
    type = text
    null = false
  }

  column "workspace_id" {
    type = uuid
    null = false
  }

  column "lead_id" {
    type = uuid
    null = false
  }

  column "created_at" {
    type = timestamptz
    null = false
    default = sql("now()")
  }

  column "updated_at" {
    type = timestamptz
    null = false
    default = sql("now()")
  }

  primary_key {
    columns = [column.id]
  }

  foreign_key "project_workspace_id_fk" {
    columns = [column.workspace_id]
    ref_columns = [table.workspace.column.id]
    on_delete = CASCADE
  }

  foreign_key "project_lead_id_fk" {
    columns = [column.lead_id]
    ref_columns = [table.user.column.id]
    on_delete = RESTRICT
  }

  index "project_workspace_slug_idx" {
    columns = [column.workspace_id, column.slug]
    unique = true
  }
}

table "project_area" {
  schema = schema.public

  column "project_id" {
    type = uuid
    null = false
  }

  column "area_id" {
    type = uuid
    null = false
  }

  column "created_at" {
    type = timestamptz
    null = false
    default = sql("now()")
  }

  primary_key {
    columns = [column.project_id, column.area_id]
  }

  foreign_key "project_area_project_id_fk" {
    columns = [column.project_id]
    ref_columns = [table.project.column.id]
    on_delete = CASCADE
  }

  foreign_key "project_area_area_id_fk" {
    columns = [column.area_id]
    ref_columns = [table.area.column.id]
    on_delete = CASCADE
  }
}

table "task" {
  schema = schema.public

  column "id" {
    type = uuid
    null = false
  }

  column "title" {
    type = text
    null = false
  }

  column "description" {
    type = text
    null = true
  }

  column "workspace_id" {
    type = uuid
    null = false
  }

  column "project_id" {
    type = uuid
    null = true
  }

  column "area_id" {
    type = uuid
    null = true
  }

  column "creator_id" {
    type = uuid
    null = false
  }

  column "assignee_id" {
    type = uuid
    null = true
  }

  column "sort_order" {
    type = float8
    null = false
  }

  column "start" {
    type = text // not_started | started | postponed
    null = false
    default = "not_started"
  }

  column "start_date" {
    type = timestamptz
    null = true
  }

  column "start_bucket" {
    type = text // today | evening
    null = false
    default = "today"
  }

  column "due_date" {
    type = timestamptz
    null = true
  }

  column "completed_at" {
    type = timestamptz
    null = true
  }

  column "archived_at" {
    type = timestamptz
    null = true
  }

  column "created_at" {
    type = timestamptz
    null = false
    default = sql("now()")
  }

  column "updated_at" {
    type = timestamptz
    null = false
    default = sql("now()")
  }

  primary_key {
    columns = [column.id]
  }

  foreign_key "task_workspace_id_fk" {
    columns = [column.workspace_id]
    ref_columns = [table.workspace.column.id]
    on_delete = CASCADE
  }

  foreign_key "task_project_id_fk" {
    columns = [column.project_id]
    ref_columns = [table.project.column.id]
    on_delete = NO_ACTION
  }

  foreign_key "task_area_id_fk" {
    columns = [column.area_id]
    ref_columns = [table.area.column.id]
    on_delete = NO_ACTION
  }

  foreign_key "task_creator_id_fk" {
    columns = [column.creator_id]
    ref_columns = [table.user.column.id]
    on_delete = RESTRICT
  }

  foreign_key "task_assignee_id_fk" {
    columns = [column.assignee_id]
    ref_columns = [table.user.column.id]
    on_delete = NO_ACTION
  }

  index "task_workspace_start_idx" {
    columns = [column.workspace_id, column.start]
  }

  index "task_workspace_start_bucket_idx" {
    columns = [column.workspace_id, column.start_bucket]
  }

  index "task_sort_order_idx" {
    columns = [column.sort_order]
  }
}

table "task_comment" {
  schema = schema.public

  column "id" {
    type = uuid
    null = false
  }

  column "task_id" {
    type = uuid
    null = false
  }

  column "author_id" {
    type = uuid
    null = false
  }

  column "content" {
    type = text
    null = false
  }

  column "created_at" {
    type = timestamptz
    null = false
    default = sql("now()")
  }

  column "updated_at" {
    type = timestamptz
    null = false
    default = sql("now()")
  }

  primary_key {
    columns = [column.id]
  }

  foreign_key "task_comment_task_id_fk" {
    columns = [column.task_id]
    ref_columns = [table.task.column.id]
    on_delete = CASCADE
  }

  foreign_key "task_comment_author_id_fk" {
    columns = [column.author_id]
    ref_columns = [table.user.column.id]
    on_delete = RESTRICT
  }
}

table "emoji" {
  schema = schema.public

  column "id" {
    type = uuid
    null = false
  }

  column "value" {
    type = text
    null = false
  }

  column "annotation" {
    type = text
    null = true
  }

  column "subject_id" {
    type = uuid
    null = false
  }

  column "creator_id" {
    type = uuid
    null = true
  }

  column "created_at" {
    type = timestamptz
    null = false
    default = sql("now()")
  }

  column "updated_at" {
    type = timestamptz
    null = false
    default = sql("now()")
  }

  primary_key {
    columns = [column.id]
  }

  foreign_key "emoji_creator_id_fk" {
    columns = [column.creator_id]
    ref_columns = [table.user.column.id]
    on_update = NO_ACTION
    on_delete = CASCADE
  }

  index "emoji_created_at_idx" {
    columns = [column.created_at]
  }

  index "emoji_subject_id_idx" {
    columns = [column.subject_id]
  }

  unique "emoji_subject_creator_value_unique" {
    columns = [column.subject_id, column.creator_id, column.value]
  }
}

table "tag" {
  schema = schema.public

  column "id" {
    type = uuid
    null = false
  }

  column "name" {
    type = text
    null = false
  }

  column "color" {
    type = text
    null = true
  }

  column "workspace_id" {
    type = uuid
    null = false
  }

  column "created_at" {
    type = timestamptz
    null = false
    default = sql("now()")
  }

  column "updated_at" {
    type = timestamptz
    null = false
    default = sql("now()")
  }

  primary_key {
    columns = [column.id]
  }

  foreign_key "tag_workspace_id_fk" {
    columns = [column.workspace_id]
    ref_columns = [table.workspace.column.id]
    on_delete = CASCADE
  }

  index "tag_workspace_name_idx" {
    columns = [column.workspace_id, column.name]
    unique = true
  }
}

table "task_tag" {
  schema = schema.public

  column "task_id" {
    type = uuid
    null = false
  }

  column "tag_id" {
    type = uuid
    null = false
  }

  column "created_at" {
    type = timestamptz
    null = false
    default = sql("now()")
  }

  primary_key {
    columns = [column.task_id, column.tag_id]
  }

  foreign_key "task_tag_task_id_fk" {
    columns = [column.task_id]
    ref_columns = [table.task.column.id]
    on_delete = CASCADE
  }

  foreign_key "task_tag_tag_id_fk" {
    columns = [column.tag_id]
    ref_columns = [table.tag.column.id]
    on_delete = CASCADE
  }
}

table "view_state" {
  schema = schema.public

  column "user_id" {
    type = uuid
    null = false
  }

  column "task_id" {
    type = uuid
    null = false
  }

  column "viewed_at" {
    type = timestamptz
    null = true
  }

  primary_key {
    columns = [column.user_id, column.task_id]
  }

  foreign_key "view_state_task_id_fk" {
    columns = [column.task_id]
    ref_columns = [table.task.column.id]
    on_update = NO_ACTION
    on_delete = CASCADE
  }

  foreign_key "view_state_user_id_fk" {
    columns = [column.user_id]
    ref_columns = [table.user.column.id]
    on_update = NO_ACTION
    on_delete = CASCADE
  }
}

table "schemaVersions" {
  schema = schema.zero
  column "minSupportedVersion" {
    null = true
    type = integer
  }
  column "maxSupportedVersion" {
    null = true
    type = integer
  }
  column "lock" {
    null    = false
    type    = boolean
    default = true
  }
  primary_key {
    columns = [column.lock]
  }
  check "zero_schema_versions_single_row_constraint" {
    expr = "lock"
  }
}
table "clients" {
  schema = schema.zero_0
  column "clientGroupID" {
    null = false
    type = text
  }
  column "clientID" {
    null = false
    type = text
  }
  column "lastMutationID" {
    null = false
    type = bigint
  }
  column "userID" {
    null = true
    type = text
  }
  primary_key {
    columns = [column.clientGroupID, column.clientID]
  }
}
table "shardConfig" {
  schema = schema.zero_0
  column "publications" {
    null = false
    type = sql("text[]")
  }
  column "ddlDetection" {
    null = false
    type = boolean
  }
  column "initialSchema" {
    null = true
    type = json
  }
  column "lock" {
    null    = false
    type    = boolean
    default = true
  }
  primary_key {
    columns = [column.lock]
  }
  check "single_row_shard_config_0" {
    expr = "lock"
  }
}
table "versionHistory" {
  schema = schema.zero_0
  column "dataVersion" {
    null = false
    type = integer
  }
  column "schemaVersion" {
    null = false
    type = integer
  }
  column "minSafeVersion" {
    null = false
    type = integer
  }
  column "lock" {
    null    = false
    type    = character(1)
    default = "v"
  }
  primary_key {
    columns = [column.lock]
  }
  check "ck_schema_meta_lock" {
    expr = "(lock = 'v'::bpchar)"
  }
}
schema "public" {
  comment = "standard public schema"
}
schema "zero" {
}
schema "zero_0" {
}
