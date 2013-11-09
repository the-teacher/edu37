namespace :db do
  namespace :tags do

    # rake db:tags:for_publications
    desc 'create tags for publications for development'
    task :for_publications => :environment do
      puts 'Tags for publications creating'

      def forming_tag_string count= 5
        tags = []
        words = ['школа', 'гимназия', 'физика', 'химия', 'уроки', 'расписание занятий',
                  'федеральная программа', 'егэ', 'тестирование, глобус', 'учительница', 'юбилей',
                  'психология', 'школьный психолог', 'эксперимент', 'опыты', 'любовь', 'день рождения', 'разное', 'новости',
                  'депутат', 'фрукты', 'индия', 'америка', 'антарктида', 'скуби дуу', 'чип и дейл',
        ]
        count.times do
          tags.push words.rand 
        end
        tags.uniq.join(', ')
      end

      i = 1
      Publication.all.each do |publication|
        publication.tag_list = forming_tag_string(7)
        publication.set_tag_list_on(:publications, forming_tag_string(7))
        publication.save!
        p "tag list for publication #{i} : #{forming_tag_string(3)}"
        i = i.next
      end      

      puts 'Tags for publication created'
    end# db:tags:for_publications    
  end#:tags
end#:db
