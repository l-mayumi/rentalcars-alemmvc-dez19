require 'rails_helper'

feature 'User finalizes rental' do
  scenario 'successfully searches for rental' do
    subsidiary = create(:subsidiary, name: 'Almeida Motors')
    category = create(:category, name: 'Deluxe', daily_rate: 10,
                      car_insurance: 10,
                      third_party_insurance: 10)
    car_model = create(:car_model, category: category)
    car = create(:car, car_model: car_model, status: :available,
                       subsidiary: subsidiary)
    user = create(:user, role: :user, subsidiary: subsidiary)
    rental = create(:rental,:with_car, start_date: '3000-01-01',
                    end_date: '3000-01-05',
                    status: :ongoing, category: category,
                    subsidiary: subsidiary, car: car)
    login_as user, scope: :user

    visit root_path
    click_on 'Locações'
    fill_in 'Código da reserva', with: rental.reservation_code
    click_on 'Buscar'
    click_on 'Encerrar Locação'

    expect(page).to have_content(rental.reservation_code)
    expect(page).to have_content('Data de início: 01 de janeiro de 3000')
    expect(page).to have_content('Data de término: 05 de janeiro de 3000')
    expect(page).to have_content("Categoria: #{rental.category.name}")
    expect(page).to have_content("Locação de: #{rental.client.name}")
    expect(page).to have_content(car.license_plate)
    expect(page).to have_content('R$ 120,00')
    expect(rental.reload).to be_ongoing
    expect(page).to have_content('Finalizar locação')
  end

  scenario 'successfully' do
    subsidiary = create(:subsidiary, name: 'Almeida Motors')
    category = create(:category, name: 'Deluxe', daily_rate: 10,
                      car_insurance: 10,
                      third_party_insurance: 10)
    car_model = create(:car_model, category: category)
    car = create(:car, car_model: car_model, status: :available,
                       subsidiary: subsidiary)
    user = create(:user, role: :user, subsidiary: subsidiary)
    rental = create(:rental,:with_car, start_date: '3000-01-01',
                    end_date: '3000-01-05',
                    status: :ongoing, category: category,
                    subsidiary: subsidiary, car: car)
    login_as user, scope: :user
    visit root_path
    click_on 'Locações'
    fill_in 'Código da reserva', with: rental.reservation_code
    click_on 'Buscar'
    click_on 'Encerrar Locação'
    click_on 'Finalizar locação'

    expect(page).to have_content('Status: finalizada')
    expect(rental.reload).to be_finalized
    expect(car.reload).to be_pending_inspection
    expect(rental.amount_charged).to eq 120.00
  end

  scenario 'with addons successfully' do
    subsidiary = create(:subsidiary, name: 'Almeida Motors')
    category = create(:category, name: 'Deluxe', daily_rate: 10,
                      car_insurance: 10,
                      third_party_insurance: 10)
    car_model = create(:car_model, category: category)
    addon = create(:addon)
    addon_item = create(:addon_item, addon: addon)
    car = create(:car, car_model: car_model, status: :available,
                       subsidiary: subsidiary)
    create(:car, car_model: car_model, status: :available,
                 subsidiary: subsidiary)
    user = create(:user, role: :user, subsidiary: subsidiary)
    rental = create(:rental, start_date: '3000-01-01',
                    end_date: '3000-01-05',
                    status: :ongoing, category: category,
                    subsidiary: subsidiary)
    rental_item = create(:rental_item, rental: rental, rentable: addon_item,
                         daily_rate: 10)
    rental_item_car = create(:rental_item, rental: rental, rentable: car,
                             daily_rate: 30)
    login_as user, scope: :user

    visit root_path
    click_on 'Locações'
    fill_in 'Código da reserva', with: rental.reservation_code
    click_on 'Buscar'
    click_on 'Encerrar Locação'
    click_on 'Finalizar locação'

    expect(page).to have_content('Status: finalizada')
    expect(rental.reload).to be_finalized
    expect(car.reload).to be_pending_inspection
    expect(rental.amount_charged).to eq 160.00
  end

  scenario 'and must be ongoing rental' do
    subsidiary = create(:subsidiary, name: 'Almeida Motors')
    category = create(:category, name: 'Deluxe')
    car_model = create(:car_model, category: category)
    car = create(:car, car_model: car_model, status: :available,
                       subsidiary: subsidiary)
    user = create(:user, role: :user, subsidiary: subsidiary)
    rental = create(:rental, start_date: '3000-01-01', end_date: '3000-01-05',
                    status: :scheduled, category: category,
                    subsidiary: subsidiary)
    login_as user, scope: :user

    visit root_path
    click_on 'Locações'
    fill_in 'Código da reserva', with: rental.reservation_code
    click_on 'Buscar'

    expect(page).not_to have_link('Encerrar locação')
    expect(page).to have_link('Iniciar Locação')
  end

  scenario 'and can be finalized by user in different subsidiary' do
    subsidiary = create(:subsidiary, name: 'Almeidinha Autos')
    other_subsidiary = create(:subsidiary, name: 'MoratoMotors')
    category = create(:category, name: 'Deluxe')
    car_model = create(:car_model, category: category)
    car = create(:car, car_model: car_model, status: :available,
                       subsidiary: other_subsidiary)
    user = create(:user, role: :user, subsidiary: subsidiary)
    rental = create(:rental,:with_car, start_date: '3000-01-01',
                    end_date: '3000-01-05', status: :ongoing,
                    category: category, subsidiary: other_subsidiary, car: car)
    login_as user, scope: :user

    visit root_path
    click_on 'Locações'
    fill_in 'Código da reserva', with: rental.reservation_code
    click_on 'Buscar'

    expect(page).not_to have_button('Encerrar locação')
  end
end
