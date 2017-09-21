user = Erp::User.first

Erp::MiniStores::ArticleCategory.all.destroy_all
Erp::MiniStores::ArticleCategory.create(
  name: "Về chúng tôi",
  alias: Erp::MiniStores::ArticleCategory::ALIAS_ABOUT,
  creator_id: user.id
)
Erp::MiniStores::ArticleCategory.create(
  name: "Hướng dẫn mua hàng",
  alias: Erp::MiniStores::ArticleCategory::ALIAS_TOUR_GUIDE,
  creator_id: user.id
)
Erp::MiniStores::ArticleCategory.create(
  name: "Chăm sóc khách hàng",
  alias: Erp::MiniStores::ArticleCategory::ALIAS_CUSTOMER_CARE,
  creator_id: user.id
)
Erp::MiniStores::ArticleCategory.create(
  name: "Điều khoản mua bán hàng hóa",
  alias: Erp::MiniStores::ArticleCategory::ALIAS_TERMS_OF_SALES,
  creator_id: user.id
)
Erp::MiniStores::ArticleCategory.create(
  name: "Phương thức thanh toán",
  alias: Erp::MiniStores::ArticleCategory::ALIAS_PAYMENT_METHODS,
  creator_id: user.id
)
Erp::MiniStores::ArticleCategory.create(
  name: "Chính sách đổi trả & hoàn tiền",
  alias: Erp::MiniStores::ArticleCategory::ALIAS_RETURN_POLICY_AND_REFUND,
  creator_id: user.id
)
Erp::MiniStores::ArticleCategory.create(
  name: "Chính sách giải quyết tranh chấp & khiếu nại",
  alias: Erp::MiniStores::ArticleCategory::ALIAS_POLICY_OF_DISPUTES_COMPLAINTS,
  creator_id: user.id
)
Erp::MiniStores::ArticleCategory.create(
  name: "Tin tức du lịch",
  alias: Erp::MiniStores::ArticleCategory::ALIAS_ARTICLE,
  creator_id: user.id
)

about = Erp::MiniStores::ArticleCategory.where(alias: Erp::MiniStores::ArticleCategory::ALIAS_ABOUT).first
tour_guide = Erp::MiniStores::ArticleCategory.where(alias: Erp::MiniStores::ArticleCategory::ALIAS_TOUR_GUIDE).first
customer_care = Erp::MiniStores::ArticleCategory.where(alias: Erp::MiniStores::ArticleCategory::ALIAS_CUSTOMER_CARE).first
terms_of_sales = Erp::MiniStores::ArticleCategory.where(alias: Erp::MiniStores::ArticleCategory::ALIAS_TERMS_OF_SALES).first
payment_methods = Erp::MiniStores::ArticleCategory.where(alias: Erp::MiniStores::ArticleCategory::ALIAS_PAYMENT_METHODS).first
return_policy_and_refund = Erp::MiniStores::ArticleCategory.where(alias: Erp::MiniStores::ArticleCategory::ALIAS_RETURN_POLICY_AND_REFUND).first
policy_of_disputes_complaints = Erp::MiniStores::ArticleCategory.where(alias: Erp::MiniStores::ArticleCategory::ALIAS_POLICY_OF_DISPUTES_COMPLAINTS).first

Erp::MiniStores::Article.all.destroy_all
Erp::MiniStores::Article.create(
  name: "Về chúng tôi",
  content: "Nội dung đang được cập nhật...",
  article_category_id: about.id,
  creator_id: user.id
)
Erp::MiniStores::Article.create(
  name: "Hướng dẫn mua hàng",
  content: "Nội dung đang được cập nhật...",
  article_category_id: tour_guide.id,
  creator_id: user.id
)
Erp::MiniStores::Article.create(
  name: "Chăm sóc khách hàng",
  content: "Nội dung đang được cập nhật...",
  article_category_id: customer_care.id,
  creator_id: user.id
)
Erp::MiniStores::Article.create(
  name: "Điều khoản mua bán hàng hóa",
  content: "Nội dung đang được cập nhật...",
  article_category_id: terms_of_sales.id,
  creator_id: user.id
)
Erp::MiniStores::Article.create(
  name: "Phương thức thanh toán",
  content: "Nội dung đang được cập nhật...",
  article_category_id: payment_methods.id,
  creator_id: user.id
)
Erp::MiniStores::Article.create(
  name: "Chính sách đổi trả & hoàn tiền",
  content: "Nội dung đang được cập nhật...",
  article_category_id: return_policy_and_refund.id,
  creator_id: user.id
)
Erp::MiniStores::Article.create(
  name: "Chính sách giải quyết tranh chấp & khiếu nại",
  content: "Nội dung đang được cập nhật...",
  article_category_id: policy_of_disputes_complaints.id,
  creator_id: user.id
)