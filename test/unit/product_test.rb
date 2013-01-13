require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  def new_procuct(image_url)
    Product.new(title:       "My Book Title",
                description: "yyy",
                price: 1,
                image_url:   image_url)
  end

  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:image_url].any?
    assert product.errors[:price].any?
  end

  test "product is not valid without a unique title" do
    product = Product.new(title:       products(:ruby).title,
                          description: "yyy",
                          price:       1,
                          image_url:   "fred.gif")
    assert !product.save
    assert_equal I18n.translate("activerecord.errors.messages.taken"),
                  product.errors[:title].join('; ')
  end

  test "product price must be positive" do
    product = new_procuct "zzz.jpg"

    product.price = -1;
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",
      product.errors[:price].join('; ')

    product.price = 0;
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",
      product.errors[:price].join('; ')

    product.price = 1;
    assert product.valid?
  end

  test "image_url" do
    ok = %w{ fled.gif fred.jpg fred.png FLED.GIF FRED.Jpg
            http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }

    ok.each do |name|
      assert new_procuct(name).valid?, "#{name} shoudn't be invalid"
    end
    bad.each do |name|
      assert new_procuct(name).invalid?, "#{name} shoudn't be valid"
    end
  end

end
