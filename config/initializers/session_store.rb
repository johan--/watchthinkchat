Rails.application.config.session_store :redis_store,
                                       expire_after: 2.days
