Lotto = require('lotto') 

describe "a lotto system", ->
    
  describe "when we use basic functions", ->
    lotto = null
    
    beforeEach ->
      lotto = new Lotto('test_basic')
    
    it "should echo back the command line", ->
      expect(lotto).toBeDefined()
      expect(lotto.echo(['echo']).toString()).toBe(['echo'].toString())
    
    it "should save and load properly", ->
      data = {name: "francois"}
      lotto.save(data)
      expect(lotto.load().name).toBe("francois")
      
    it "should produce a proper new state", ->
      s = lotto.newState(100)
      expect(s.total).toBe(100)
      expect(s.players.length).toBe(0)      
      expect(s.winners.length).toBe(0)

  describe "when exec is called", ->
    lotto = null
    
    beforeEach ->
      lotto = new Lotto('test_exec')
  
    it "should throw when undefined", ->
      err = "NOT THROWN"
      try
        lotto.exec()
      catch error
        err = error
      expect(err.toString()).toBe("commande invalide")

    it "should throw when empty", ->
      err = "NOT THROWN"
      try
        lotto.exec([])
      catch error
        err = error
      expect(err.toString()).toBe("commande invalide")

    it "should return ignoree when ignorer is called", ->
      err = "OK"
      ret = "NOTHING RETURNED"
      try
        ret = lotto.exec(["ignorer"])
      catch error
        err = error
      expect(err).toBe("OK")
      expect(ret).toBe("ignoree")

    it "should echo when echo is called", ->
      ret = lotto.exec(["echo","same"])
      expect(ret).toBe("same")

    it "should return effacee when effacer is called", ->
      ret = lotto.exec(["effacer"])
      expect(ret).toBe("effacee")

    it "should return its status", ->
      data = {name: "francois"}
      lotto.save(data)
      ret = lotto.exec(["status"])
      expect(ret).toBe('{"name":"francois"}')

  describe "when the state is reset", ->
    lotto = null
    
    beforeEach ->
      lotto = new Lotto('test_reset')
      lotto.clear(200)

    it "should have a total of 200", ->
      expect(lotto.load().total).toBe(200)
      
    it "should have no players", ->
      expect(lotto.load().players.length).toBe(0)

  describe "when prizes are determined", ->
    lotto = null
    
    beforeEach ->
      lotto = new Lotto('test_prizes')

    it "should have a first prize of 75% of 50%", ->
      expect(lotto.prizes(100)[0]).toBe(37.5)
      expect(lotto.prizes(200)[0]).toBe(75)
      expect(lotto.prizes(400)[0]).toBe(150)

    it "should have a second prize of 15% of 50%", ->
      expect(lotto.prizes(100)[1]).toBe(7.5)
      expect(lotto.prizes(200)[1]).toBe(15)
      expect(lotto.prizes(400)[1]).toBe(30)

    it "should have a second prize of 10% of 50%", ->
      expect(lotto.prizes(100)[2]).toBe(5)
      expect(lotto.prizes(200)[2]).toBe(10)
      expect(lotto.prizes(400)[2]).toBe(20)

    it "should value tickets at 10$", ->
      expect(lotto.ticketPrice()).toBe(10)

  describe "when I buy a ticket", ->
    lotto = null
    
    beforeEach ->
      lotto = new Lotto('test_tickets')
      
    describe "when I'm the first buyer", ->
      it "should accept my name and show me ticket number 1", ->
        lotto.clear()
        out = lotto.achat("francois leduc")
        expect(out).toBe("francois leduc - boule 1")
      
      it "should have 10$ in the total", ->
        data = lotto.load()
        expect(data.total).toBe(10)
        

    describe "when I'm the second buyer", ->
      it "should accept my name and show me ticket number 2", ->
        lotto.clear()
        lotto.achat("first guy")
        out = lotto.achat("francois leduc")
        expect(out).toBe("francois leduc - boule 2")

      it "should have 20$ in the total", ->
        data = lotto.load()
        expect(data.total).toBe(20)

    describe "when I'm the 50th buyer", ->
      it "should accept my name and show me ticket number 50", ->
        lotto.clear()
        lotto.achat(num + "th guy") for num in [1..49]
        out = lotto.achat("francois leduc")
        expect(out).toBe("francois leduc - boule 50")

      it "should have 500$ in the total", ->
        data = lotto.load()
        expect(data.total).toBe(500)
    
    describe "when I'm the 51st buyer", ->
      it "should refuse to sell me a ticket", ->
        lotto.clear()
        lotto.achat(num + "th guy") for num in [1..50]
        err = "NOT THROWN"
        try
          out = lotto.achat("francois leduc")
        catch error
          err = error
        
        expect(err.toString()).toBe("aucun billet disponible")
        
      it "should have 500$ in the total", ->
        data = lotto.load()
        expect(data.total).toBe(500)

  describe "when there is a draw", ->

    describe "when random numbers are generated", ->

      it "should pick a random number between 1 and 50", ->
        lotto = new Lotto('test_random')
        i = 1
        while i <= 1000
          number = lotto.pick(1,50)
          expect(number).toBeGreaterThan(0)
          expect(number).toBeLessThan(51)
          i++

      it "should pick 1,2,3 out of 50", ->
        group = []
        group.push(num) for num in [1..50]
        i = 1
        while i <= 1
          picker = new Lotto()
          f = (min, max) ->
            1
          picker.use_random f
          numbers = picker.choose(group, 3)
          expect(group.toString()).toBe([1..50].toString())
          expect(numbers.toString()).toBe([1..3].toString())
          i++
          
    describe "when it picks numbers", ->
      it "should pick 1 number per prize", ->
        picker = new Lotto('test_picker')
        f = (min, max) ->
          1
        picker.use_random f
        picker.clear()
        picker.achat(num + "th guy") for num in [1..20]
        out = picker.draw(3)
        expect(out).toBeDefined()
        expect(out.toString()).toBe("3 gagnants choisis")
        data = picker.load()
        expect(data.players.length).toBe(20)
        expect(data.winners.toString()).toBe([ '1th guy', '2th guy', '3th guy' ].toString())

    describe "when we want to see the results", ->
      it "should tell you when there are no results", ->
        picker = new Lotto('test_results')
        picker.clear()
        out = picker.show_winner_table()
        expect(out).toBe("Aucun resultat")

      it "should calculate column widths", ->
        picker = new Lotto('test_results')
        grid = []
        grid.push(['cell 1','long text just to check', '', 'equal'])
        grid.push(['cell 12','short', '', 'equal'])
        widths = (picker.largest_row_width(grid, col) for col in [0..3])
        expect(widths.toString()).toBe([7,23,0,5].toString())

      describe "when we produce dividers", ->
        div = new Lotto('test_divs')

        it "should produce a padded string", ->
          str = div.pad('-', 5)
          expect(str).toBe('-----')
          str = div.pad(',', 0)
          expect(str).toBe('')
          str = div.pad('+', 1)
          expect(str).toBe('+')

        it "should produce a row of " + ('|-|'.length) + " for cell []", ->
          widths = []
          divider = div.divider(widths)
          expect(divider.length).toBe('|-|'.length)

        it "should produce a row of " + ('|-|'.length) + " for cell [0]", ->
          widths = [0]
          divider = div.divider(widths)
          expect(divider.length).toBe('|-|'.length)

        it "should produce a row of " + ('|-1-|'.length) + " for cells [1]", ->
          widths = [1]
          divider = div.divider(widths)
          expect(divider.length).toBe('|-1-|'.length)

        it "should produce a row of " + ('|-|-|'.length) + " for cells [0,0]", ->
          widths = [0,0]
          divider = div.divider(widths)
          expect(divider.length).toBe('|-|-|'.length)

        it "should produce a row of " + ('|-1-|-1-|'.length) + " for cells [1,1]", ->
          widths = [1,1]
          divider = div.divider(widths)
          expect(divider.length).toBe('|-1-|-1-|'.length)

        it "should produce a row of " + ('|-1-|-1-|-1-|'.length) + " for cells [1,1,1]", ->
          widths = [1,1,1]
          divider = div.divider(widths)
          expect(divider.length).toBe('|-1-|-1-|-1-|'.length)

        it "should produce a row of " + ('|-1-|-1-|-1-|-1-|'.length) + " for cells [1,1,1,1]", ->
          widths = [1,1,1,1]
          divider = div.divider(widths)
          expect(divider.length).toBe('|-1-|-1-|-1-|-1-|'.length)

        it "should produce a row of " + ('| 1234567 | 12345678901234567890123 | | 12345 |'.length) + " for cells [7,23,0,5]", ->
          widths = [7,23,0,5]
          divider = div.divider(widths)
          expect(divider.length).toBe('| 1234567 | 12345678901234567890123 | | 12345 |'.length)

      describe "when we produce rows", ->
        div = new Lotto('test_rows')

        it "should produce row | |' for cell []", ->
          cells = []
          row = div.row(cells)
          expect(row).toBe('| |')

        it "should produce row | |' for cell ['']", ->
          cells = ['']
          widths = [0]
          row = div.row(cells, widths)
          expect(row).toBe('| |')

        it "should produce row | 1 |' for cell ['1']", ->
          cells = ['1']
          widths = [1]
          row = div.row(cells, widths)
          expect(row).toBe('| 1 |')

        it "should produce row | 1 | 2 |' for cell ['1','2']", ->
          cells = ['1','2']
          widths = [1,1]
          row = div.row(cells, widths)
          expect(row).toBe('| 1 | 2 |')

        it "should produce row | 1 | 22 | 333 |' for cell ['1','22','333']", ->
          cells = ['1','22','333']
          widths = [1,2,3]
          row = div.row(cells, widths)
          expect(row).toBe('| 1 | 22 | 333 |')

        it "should produce a row | 1234567 | 12345678901234567890123 | | 12345 | for cells [7,23,0,5]", ->
          cells = ['1234567','12345678901234567890123','','12345']
          widths = [7,23,0,5]
          row = div.row(cells, widths)
          expect(row).toBe('| 1234567 | 12345678901234567890123 | | 12345 |')

      describe "when we produce tables", ->
        div = new Lotto('test_tables')

        it "should produce a proper table for []", ->
          table = []
          table.push []
          txt = div.table(table)
          expect('\n' + txt).toBe('\n---\n---')

        it "should produce a proper table for [[1]]", ->
          table = []
          table.push ['1']
          txt = div.table(table)
          expect('\n' + txt).toBe('\n-----\n| 1 |\n-----')

        it "should produce a proper table for results", ->
          table = []
          table.push ['1ere boule','2eme boule','3eme boule']
          table.push ['Andre : 75$','Sylvie : 15$','Dominic : 10$']
          txt = div.table(table)
          expect('\n' + txt).toBe('\n----------------------------------------------\n| 1ere boule  | 2eme boule   | 3eme boule    |\n----------------------------------------------\n| Andre : 75$ | Sylvie : 15$ | Dominic : 10$ |\n----------------------------------------------')

      describe "when we produce results", ->
        game = null

        beforeEach ->
          game = new Lotto('test_winners')
          data = JSON.parse('{"total":200,"players":["Andre","Sylvie","Dominic"],"winners":[]}')
          game.save(data)
          f = (min, max) ->
            1
          game.use_random f
          game.draw(3)

        it "should produce a proper table for results", ->
          txt = game.show_winner_table()
          expect('\n' + txt).toBe('\n----------------------------------------------\n| 1ere boule  | 2eme boule   | 3eme boule    |\n----------------------------------------------\n| Andre : 75$ | Sylvie : 15$ | Dominic : 10$ |\n----------------------------------------------')
